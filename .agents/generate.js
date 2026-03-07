#!/usr/bin/env node
"use strict";

const fs = require("fs");
const path = require("path");
const yaml = require("js-yaml");
const Handlebars = require("handlebars");

const ROOT = path.resolve(__dirname, "..");
const AGENTS_DIR = __dirname;

// --- helpers ---

Handlebars.registerHelper("json", (val) => JSON.stringify(val));
Handlebars.registerHelper("join", (arr, sep) =>
  Array.isArray(arr) ? arr.join(sep) : String(arr)
);
Handlebars.registerHelper("jsonKey", (val) => JSON.stringify(String(val)));
Handlebars.registerHelper("jsonString", (val) => JSON.stringify(String(val)));

function readFile(filePath) {
  return fs.readFileSync(filePath, "utf8");
}

function writeFile(filePath, content) {
  fs.mkdirSync(path.dirname(filePath), { recursive: true });
  fs.writeFileSync(filePath, content.trimEnd() + "\n", "utf8");
}

function loadTemplate(templatePath) {
  return Handlebars.compile(readFile(templatePath));
}

function loadYaml(filePath) {
  return yaml.load(readFile(filePath));
}

// Strip shebang from skill content so we don't duplicate it
function stripShebang(content) {
  return content.replace(/^#!.*\n/, "");
}

// Split YAML frontmatter from body. Returns { frontmatter, body }.
// frontmatter includes the surrounding --- delimiters and trailing newline.
// body is everything after the closing ---.
function splitFrontmatter(content) {
  const match = content.match(/^(---\n[\s\S]*?\n---\n)([\s\S]*)$/);
  if (match) return { frontmatter: match[1], body: match[2] };
  return { frontmatter: "", body: content };
}

// Downshift markdown headings by N levels (# → ##, ## → ###, etc.)
function downshiftHeadings(content, levels) {
  const prefix = "#".repeat(levels);
  return content.replace(/^(#{1,6}) /gm, (_, hashes) => {
    const newLevel = Math.min(hashes.length + levels, 6);
    return "#".repeat(newLevel) + " ";
  });
}

Handlebars.registerHelper("downshift", (content, levels) =>
  downshiftHeadings(String(content), Number(levels))
);

// --- load data ---

const config = loadYaml(path.join(AGENTS_DIR, "data/config.yaml"));
const agentsData = loadYaml(path.join(AGENTS_DIR, "data/agents.yaml"));
const commandsData = loadYaml(path.join(AGENTS_DIR, "data/commands.yaml"));
const skillsData = loadYaml(path.join(AGENTS_DIR, "data/skills.yaml"));

// --- CLI args ---

const args = process.argv.slice(2);
const platformIdx = args.indexOf("--platform");
const typeIdx = args.indexOf("--type");

const platformFilter = platformIdx !== -1 ? args[platformIdx + 1] : null;
const typeFilter = typeIdx !== -1 ? args[typeIdx + 1] : null;

const platforms = platformFilter
  ? [platformFilter]
  : ["cursor", "claude", "opencode"];
const types = typeFilter ? [typeFilter] : ["agents", "commands", "skills"];

const written = [];

// --- generators ---

function generateCursor() {
  if (types.includes("agents")) {
    const tmpl = loadTemplate(
      path.join(AGENTS_DIR, "templates/cursor/agent.md.hbs")
    );
    for (const agent of agentsData.agents) {
      if (!agent.platforms.includes("cursor")) continue;
      const srcPath = path.join(AGENTS_DIR, "agents", `${agent.name}.md`);
      const content = readFile(srcPath);
      const rendered = tmpl({ name: agent.name, content });
      const outPath = path.join(
        ROOT,
        config.output.cursor.agents,
        `${agent.name}.md`
      );
      writeFile(outPath, rendered);
      written.push(outPath);
    }
  }

  if (types.includes("commands")) {
    const tmpl = loadTemplate(
      path.join(AGENTS_DIR, "templates/cursor/command.md.hbs")
    );
    for (const cmd of commandsData.commands) {
      if (!cmd.platforms.includes("cursor")) continue;
      const srcPath = path.join(AGENTS_DIR, "commands", `${cmd.name}.md`);
      const content = readFile(srcPath);
      const rendered = tmpl({ name: cmd.name, content });
      const outPath = path.join(
        ROOT,
        config.output.cursor.commands,
        `${cmd.name}.md`
      );
      writeFile(outPath, rendered);
      written.push(outPath);
    }
  }

  if (types.includes("skills")) {
    const tmpl = loadTemplate(
      path.join(AGENTS_DIR, "templates/cursor/skill.sh.hbs")
    );
    for (const skill of skillsData.skills) {
      if (!skill.platforms.includes("cursor")) continue;
      const srcPath = path.join(AGENTS_DIR, "skills", `${skill.name}.sh`);
      const rawContent = readFile(srcPath);
      const content = stripShebang(rawContent);
      const rendered = tmpl({ name: skill.name, content });
      const outPath = path.join(
        ROOT,
        config.output.cursor.skills,
        `${skill.name}.${skill.output_ext}`
      );
      writeFile(outPath, rendered);
      written.push(outPath);
    }
  }
}

function generateClaude() {
  if (types.includes("agents")) {
    const tmpl = loadTemplate(
      path.join(AGENTS_DIR, "templates/claude/agent.md.hbs")
    );
    for (const agent of agentsData.agents) {
      if (!agent.platforms.includes("claude")) continue;
      const srcPath = path.join(AGENTS_DIR, "agents", `${agent.name}.md`);
      const content = readFile(srcPath);
      const rendered = tmpl({
        name: agent.name,
        description: agent.description,
        tools: agent.claude_tools,
        content,
      });
      const outPath = path.join(
        ROOT,
        config.output.claude.agents,
        `${agent.name}.md`
      );
      writeFile(outPath, rendered);
      written.push(outPath);
    }
  }

  if (types.includes("commands")) {
    const tmpl = loadTemplate(
      path.join(AGENTS_DIR, "templates/claude/command.md.hbs")
    );
    for (const cmd of commandsData.commands) {
      if (!cmd.platforms.includes("claude")) continue;
      const srcPath = path.join(AGENTS_DIR, "commands", `${cmd.name}.md`);
      const raw = readFile(srcPath);
      const { frontmatter, body } = splitFrontmatter(raw);
      const rendered = tmpl({ name: cmd.name, frontmatter, body });
      const outPath = path.join(
        ROOT,
        config.output.claude.commands,
        `${cmd.name}.md`
      );
      writeFile(outPath, rendered);
      written.push(outPath);
    }
  }
}

function generateOpencode() {
  const tmpl = loadTemplate(
    path.join(AGENTS_DIR, "templates/opencode/AGENTS.md.hbs")
  );

  // Build per-agent content map for partial rendering
  const agents = agentsData.agents.map((a) => {
    const srcPath = path.join(AGENTS_DIR, "agents", `${a.name}.md`);
    return { ...a, _content: readFile(srcPath) };
  });

  const rendered = tmpl({
    agents,
    commands: commandsData.commands,
    skills: skillsData.skills,
  });

  const outPath = path.join(ROOT, config.output.opencode.agents_doc);
  writeFile(outPath, rendered);
  written.push(outPath);

  // Generate plugin
  const pluginTmpl = loadTemplate(
    path.join(AGENTS_DIR, "templates/opencode/index.js.hbs")
  );
  const commands = commandsData.commands.map((cmd) => {
    const srcPath = path.join(AGENTS_DIR, "commands", `${cmd.name}.md`);
    const raw = readFile(srcPath);
    const { body } = splitFrontmatter(raw);
    return { ...cmd, body: body.trim() };
  });
  const pluginRendered = pluginTmpl({ commands });
  const pluginOutPath = path.join(ROOT, config.output.opencode.plugin);
  writeFile(pluginOutPath, pluginRendered);
  written.push(pluginOutPath);
}

// --- main ---

for (const platform of platforms) {
  if (platform === "cursor") generateCursor();
  else if (platform === "claude") generateClaude();
  else if (platform === "opencode") generateOpencode();
  else {
    console.error(`Unknown platform: ${platform}`);
    process.exit(1);
  }
}

console.log(`\nGenerated ${written.length} file(s):`);
for (const f of written) {
  console.log(`  ${path.relative(ROOT, f)}`);
}

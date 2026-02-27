Feature: WezTerm config loader
  The WezTerm config is built by chaining modules via a loader that merges
  options. Duplicate keys should be detected and logged, not silently overwritten.

  Scenario: Appending options merges new keys into config
    Given a fresh WezTerm loader instance
    When I append options { font_size = 12 }
    And I append options { line_height = 1.2 }
    Then the config has key "font_size" with value 12
    And the config has key "line_height" with value 1.2

  Scenario: Appending duplicate key does not overwrite and is reported
    Given a fresh WezTerm loader instance
    When I append options { font_size = 12 }
    And I append options { font_size = 14 }
    Then the config key "font_size" is still 12
    And a duplicate config warning was logged for "font_size"

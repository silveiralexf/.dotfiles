Feature: WezTerm backdrops extension
  The Backdrops module manages a list of background images and supports
  cycling and setting by index. Edge cases (empty list, index out of range)
  must be handled safely.

  Scenario: Cycle forward wraps from last to first
    Given backdrops with files { "a.png", "b.png", "c.png" }
    And current index is 3
    When I cycle forward
    Then current index is 1
    And current background file is "a.png"

  Scenario: Cycle back wraps from first to last
    Given backdrops with files { "a.png", "b.png", "c.png" }
    And current index is 1
    When I cycle back
    Then current index is 3
    And current background file is "c.png"

  Scenario: Set image by index validates range
    Given backdrops with files { "a.png", "b.png" }
    When I set image at index 2
    Then current index is 2
    And current background file is "b.png"

  Scenario: Set image with index out of range logs error and does not change index
    Given backdrops with files { "a.png" }
    And current index is 1
    When I set image at index 5
    Then an error was logged for index out of range
    And current index is still 1

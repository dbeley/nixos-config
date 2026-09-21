_: {
  services.thinkfan = {
    enable = true;
    sensors = [
      {
        type = "tpacpi";
        query = "/proc/acpi/ibm/thermal";
        indices = [ 0 ];
      }
    ];

    # [ fan-level  step-down-temp  step-up-temp ]
    levels = [
      [
        0
        0
        47
      ]
      [
        1
        44
        52
      ]
      [
        2
        50
        57
      ]
      [
        3
        55
        62
      ]
      [
        4
        60
        67
      ]
      [
        5
        65
        72
      ]
      [
        6
        70
        77
      ]
      [
        7
        75
        88
      ]
      [
        "level disengaged"
        85
        32767
      ]
    ];
  };
}

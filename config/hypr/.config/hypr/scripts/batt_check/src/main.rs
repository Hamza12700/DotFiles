use std::{
  fs::File,
  io::{BufRead, BufReader},
  process::{self, Command},
};

#[derive(PartialEq)]
enum BatteryLevels {
  None,
  Low,
  HalfFull,
  AlmostEmpty,
}

fn main() {
  let mut battery_level_check = BatteryLevels::None;
  loop {
    let battery_cap_file = File::open("/sys/class/power_supply/BAT0/capacity")
      .expect("Failed to open battery capacity file");

    let mut reader = BufReader::new(battery_cap_file);
    let mut battery_level = String::new();
    if let Err(err) = reader.read_line(&mut battery_level) {
      eprintln!("Failed to read battery capacity: {}", err);
      process::exit(1);
    };

    let battery_level: u8 = battery_level
      .trim()
      .parse()
      .expect("Failed to parse battery capacity to u8");

    match battery_level {
      40..=50 if battery_level_check != BatteryLevels::HalfFull => {
        get_notified("Battery is half full", battery_level);
        battery_level_check = BatteryLevels::HalfFull
      }
      21..=30 if battery_level_check != BatteryLevels::Low => {
        get_notified("Battery is low", battery_level);
        battery_level_check = BatteryLevels::Low
      }
      10..=20 if battery_level_check != BatteryLevels::AlmostEmpty => {
        get_notified("Battery is almost empty", battery_level);
        battery_level_check = BatteryLevels::AlmostEmpty
      }
      100 => get_notified("Battery is fully charged", battery_level),
      _ => (),
    };

    std::thread::sleep(std::time::Duration::from_secs(60));
  }
}

fn get_notified(title: &str, battery_cap: u8) {
  let _ = Command::new("notify-send")
    .arg(title)
    .arg(format!("{}%", battery_cap))
    .output()
    .expect("Failed to send notification");
}

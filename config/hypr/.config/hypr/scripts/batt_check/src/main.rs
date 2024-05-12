use std::{fs, process::Command};

#[derive(PartialEq)]
enum BatteryLevel {
  None,
  Full,
  HalfFull,
  Low,
}

fn main() {
  let mut battery_level_check = BatteryLevel::None;
  let mut check_arg = std::env::args();
  loop {
    let battery_cap_file = fs::read_to_string("/sys/class/power_supply/BAT0/capacity").unwrap();
    let battery_status = fs::read_to_string("/sys/class/power_supply/BAT0/status").unwrap();
    let battery_status = battery_status.trim();

    let battery_level: u8 = battery_cap_file
      .trim()
      .parse()
      .expect("Failed to parse battery capacity to u8");

    if let Some(check) = check_arg.nth(1) {
      if check.contains("-s") {
        println!("Battery status: {}", battery_level);
      }
      std::process::exit(0);
    };

    if battery_status == "Charging" {
      if battery_level == 100 {
        get_notified("Battery is fully charged", battery_level);
        battery_level_check = BatteryLevel::Full;
        continue;
      }
      battery_level_check = BatteryLevel::None;
      std::thread::sleep(std::time::Duration::from_secs(60));
      continue;
    };

    match battery_level {
      98..=100 if battery_level_check != BatteryLevel::Full => {
        get_notified("Battery is full", battery_level);
        battery_level_check = BatteryLevel::Full
      }
      40..=50 if battery_level_check != BatteryLevel::HalfFull => {
        get_notified("Battery is half full", battery_level);
        battery_level_check = BatteryLevel::HalfFull
      }
      21..=30 if battery_level_check != BatteryLevel::Low => {
        get_notified("Battery is low", battery_level);
        battery_level_check = BatteryLevel::Low
      }
      10..=20 => get_notified("Battery is almost empty", battery_level),
      _ => (),
    };

    std::thread::sleep(std::time::Duration::from_secs(60));
  }
}

#[inline]
fn get_notified(title: &str, battery_cap: u8) {
  let _ = Command::new("notify-send")
    .arg(title)
    .arg(format!("{}%", battery_cap))
    .output()
    .expect("Failed to send notification");
}

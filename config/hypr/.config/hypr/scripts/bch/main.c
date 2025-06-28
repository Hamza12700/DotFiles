#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define TIME 30
#define BATCAP "/sys/class/power_supply/BAT0/capacity"
#define BATSTAT "/sys/class/power_supply/BAT0/status"

enum BatteryLevel { None, Half, Low };

// Compare null-terminated strings
bool str_cmp(const char *s1, const char *s2) {
  if (strlen(s1) != strlen(s2)) return false;

  for (int i = 0; s1[i] != '\0'; i++) {
    if (s1[i] != s2[i]) return false;
  }
  return true;
}

const char *read_file(const char *filename, char *buffer, size_t buf_size) {
  FILE *open_file = fopen(filename, "r");
  if (!open_file) {
    fprintf(stderr, "Failed to open file: %s", filename);
    exit(1);
  }
  if (!fgets(buffer, buf_size, open_file)) {
    perror("Failed to read file into the buffer");
    exit(1);
  }
  fclose(open_file);
  return buffer;
}

inline void notify(const char *title, uint8_t battery_level) {
  char buffer[100];
  sprintf(buffer, "notify-send \"%s\" \"%d\"", title, battery_level);
  system(buffer);
}

inline bool range(uint8_t battery_level, uint8_t low, uint8_t high) {
  if (battery_level >= low && battery_level <= high) {
    return true;
  }
  return false;
}

void main(int argv, char *argc[]) {
  if (argv > 1) {
    char capacity_buf[8];
    const char *capacity = read_file(BATCAP, capacity_buf, 8);
    char status_buf[10];
    const char *status = read_file(BATSTAT, status_buf, 10);

    if (str_cmp(status, "Charging\n")) {
      puts("Status: Charging");
      printf("Battery: %s", capacity);
      return;
    }
    puts("Status: Discharging");
    printf("Battery: %s", capacity);
    return;
  }

  enum BatteryLevel battery_status = None;

  while (true) {
    char capacity_buf[8];
    const char *capacity = read_file(BATCAP, capacity_buf, 8);
    char status_buf[10];
    const char *status = read_file(BATSTAT, status_buf, 10);

    if (str_cmp(status, "Full\n")) {
      notify("Battery is fully charged", 100);
      sleep(TIME);
      continue;
    }

    // Should never fail because the file contains valid numerical value: 0-100
    uint8_t battery_level = atoi(capacity);

    if (range(battery_level, 40, 50) && battery_status != Half &&
        str_cmp(status, "Charging\n") != true) {
      notify("Battery is half", battery_level);
      battery_status = Half;
    } else if (range(battery_level, 10, 20) &&
               str_cmp(status, "Charging\n") != true && battery_status != Low) {
      notify("Battery is almost empty", battery_level);
      battery_status = Low;
    } else if (range(battery_level, 1, 9) &&
               str_cmp(status, "Charging\n") != true) {
      notify("Battery is dead", battery_level);
    }

    sleep(TIME);
  }
}

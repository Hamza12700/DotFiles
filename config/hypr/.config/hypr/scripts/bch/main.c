#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <stdbool.h>

enum BatteryLeve { None, Half, Low };

static inline const char* read_file(const char* filename, char* buffer, size_t buf_size) {
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

static inline void notify(const char* title, uint8_t battery_level) {
  char buffer[100];
  sprintf(buffer, "notify-send \"%s\" \"%d\"", title, battery_level);
  system(buffer);
}

static inline bool range(uint8_t battery_level, uint8_t low, uint8_t high) {
  if (battery_level >= low && battery_level <= high) {
    return true;
  }
  return false;
}

int main(int argv, char* argc[]) {
  if (argv > 1) {
    char capacity_buf[8];
    const char* capacity = read_file("/sys/class/power_supply/BAT0/capacity", capacity_buf, 8);
    char status_buf[10];
    const char* status = read_file("/sys/class/power_supply/BAT0/status", status_buf, 10);

    if (strcmp(status, "Charging\n") == 0) {
      puts("Status: Charging");
      printf("Battery: %s", capacity);
      exit(0);
    }
    printf("Battery: %s", capacity);
    exit(0);
  }
  enum BatteryLeve battery_status = None;

  while (true) {
    char capacity_buf[8];
    const char* capacity = read_file("/sys/class/power_supply/BAT0/capacity", capacity_buf, 8);
    char status_buf[10];
    const char* status = read_file("/sys/class/power_supply/BAT0/status", status_buf, 10);

    uint8_t battery_level = atoi(capacity);
    if(strcmp(status, "Full\n") == 0) {
      notify("Battery is fully charged", battery_level);
    } else {
      if (range(battery_level, 40, 50) && battery_status != Half && strcmp(status, "Charging\n") != 0) {
        notify("Battery is half", battery_level);
        battery_status = Half;
      } else if (range(battery_level, 20, 30) && battery_status != Low && strcmp(status, "Charging\n") != 0) {
        notify("Battery is low", battery_level);
        battery_status = Low;
      } else if (range(battery_level, 10, 20) && strcmp(status, "Charging\n") != 0) {
        notify("Battery is almost empty", battery_level);
      } else if (range(battery_level, 1, 9) && strcmp(status, "Charging\n") != 0) {
        notify("Battery is dead", battery_level);
      }
    }
    
    sleep(60);
  }
}

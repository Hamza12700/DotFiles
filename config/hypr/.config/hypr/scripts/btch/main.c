#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

typedef enum {
  None,
  Full,
  HalfFull,
  Low
} BatteryLevel;

BatteryLevel battery_level_check = None;

void get_notified(const char *title, int battery_cap) {
  char command[100];
  sprintf(command, "notify-send \"%s\" \"%d%%\"", title, battery_cap);
  system(command);
}

int main(int argc, char *argv[]) {
  while (1) {
    FILE *battery_cap_file =
        fopen("/sys/class/power_supply/BAT0/capacity", "r");
    FILE *battery_status_file =
        fopen("/sys/class/power_supply/BAT0/status", "r");

    if (!battery_cap_file || !battery_status_file) {
      perror("Error opening file");
      exit(EXIT_FAILURE);
    }

    char battery_cap_string[10];
    fscanf(battery_cap_file, "%s", battery_cap_string);
    fclose(battery_cap_file);

    char battery_status[20];
    fscanf(battery_status_file, "%s", battery_status);
    fclose(battery_status_file);

    int battery_level = atoi(battery_cap_string);

    if (argc >= 2 && strcmp(argv[1], "-s") == 0) {
      printf("Battery status: %d\n", battery_level);
      exit(EXIT_SUCCESS);
    }

    if (strcmp(battery_status, "Charging") == 0) {
      if (battery_level == 100) {
        if (battery_level_check != Full) {
          get_notified("Battery is fully charged", battery_level);
          battery_level_check = Full;
        }
      } else {
        battery_level_check = None;
      }
    } else {
      if (battery_level == 100 || battery_level == 99) {
        if (battery_level_check != Full) {
          get_notified("Battery is full", battery_level);
          battery_level_check = Full;
        }
      } else if (battery_level >= 40 && battery_level <= 50) {
        if (battery_level_check != HalfFull) {
          get_notified("Battery is half full", battery_level);
          battery_level_check = HalfFull;
        }
      } else if (battery_level >= 25 && battery_level <= 30) {
        if (battery_level_check != Low) {
          get_notified("Battery is low", battery_level);
          battery_level_check = Low;
        }
      } else if (battery_level >= 10 && battery_level <= 20) {
        get_notified("Battery is almost empty", battery_level);
      }
    }

    sleep(60);
  }

  return 0;
}

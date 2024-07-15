{
  services.hypridle = {
    enable = true;
    importantPrefixes = [
      "$lock_cmd = pidof hyprlock || hyprlock"
      "$suspend_cmd = pidof steam || systemctl suspend || loginctl suspend"
    ];
    settings = {
      general = {
        lock_cmd = "$lock_cmd";
        before_sleep_cmd = "$lock_cmd";
      };

      listener = [
        {
          timeout = 900; # 15mins
          on-timeout = "$lock_cmd";
        }
        {
          timeout = 1200; # 20mins
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };
}

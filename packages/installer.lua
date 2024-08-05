print("Checking YAY AUR-Helper")
local status, _ = pcall(function()
  os.execute("yay --version")
end)

if not status then
  print("Installing YAY AUR-Helper")
  os.execute("git clone https://aur.archlinux.org/yay.git")
  os.execute("cd yay && makepkg -si")
  os.execute("rm -rf yay")
end

print("Installing packages\n")
local pkgs = io.open("./package", "rb")
local content = pkgs:read("a")
os.execute("yay -S " .. content)
pkgs:close()

print("CPU TYPE (amd/intel):")
local cpu_type = io.read()
if cpu_type == "amd" then
  print("Installing AMD drivers")
  local amd_drivers = io.open("amd-drivers", "rb")
  local drivers = amd_drivers:read("a")
  os.execute("yay -S " .. drivers)
  amd_drivers:close()
else
  print("Installing INTEL drivers")
  local intel_drivers = io.open("intel-drivers", "rb")
  local contenet = intel_drivers:read("a")
  os.execute("yay -S " .. contenet)
  intel_drivers:close()
end


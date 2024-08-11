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
if pkgs == nil then
  print("package file not found")
  return
end

local content = pkgs:read("a")
os.execute("yay -S " .. content)
pkgs:close()

print("CPU TYPE (amd/intel):")
local cpu_type = io.read()
if cpu_type == "amd" then
  print("Installing AMD drivers")
  local amd_drivers = io.open("amd-drivers", "rb")
  if amd_drivers == nil then
    print("amd drivers file not found")
    return
  end

  local drivers = amd_drivers:read("a")
  os.execute("yay -S " .. drivers)
  amd_drivers:close()
else
  print("Installing INTEL drivers")
  local intel_drivers = io.open("intel-drivers", "rb")
  if intel_drivers == nil then
    print("intel drivers file not found")
    return
  end

  local contenet = intel_drivers:read("a")
  os.execute("yay -S " .. contenet)
  intel_drivers:close()
end

-- Close my nvim config
local file, _ = io.popen("ls -d ~/.config/nvim 2>/dev/null")
if file then
  file:close()
else
  os.execute("git clone https://github.com/hamza12700/nvim ~/.config/nvim")
end

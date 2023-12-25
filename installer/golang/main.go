const yayGit string = "git clone https://aur.archlinux.org/yay.git"
	cmd := exec.Command("clear")
	cmd.Stdout = os.Stdout
	cmd.Run()

func isCommandAvailable(commandName string) bool {
	color.Green("Checking if '%s' command exist", commandName)
	cmd := exec.Command("/bin/sh", "-c", "command -v "+commandName)
	if err := cmd.Run(); err != nil {
		return false
	}
	return true
}

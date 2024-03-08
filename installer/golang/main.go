package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"os/exec"
	"strings"
)

func main() {
	fmt.Println("Starting the intaller")

	_, err := exec.LookPath("stow")
	if err != nil {
		fmt.Println("Installing stow")
		cmd := exec.Command("sudo", "pacman", "-S", "stow")
		cmd.Stdout = os.Stdout
		cmd.Stdin = os.Stdin

		err = cmd.Run()
		if err != nil {
			log.Fatal(err)
		}
	}

	stow := exec.Command("stow", "*/", "-t", "~/")
	stow.Dir = "../../config/"
	stow.Stdout = os.Stdout
	if err := stow.Run(); err != nil {
	  log.Fatal(err)
	}

	fmt.Println("\nSuccessfully linked the config directories")

	file, err := os.Open("../../README.md")
	if err != nil {
		log.Fatal(err)
	}

	scanner := bufio.NewScanner(file)
	pkgs := ""
	isFound := false
	for scanner.Scan() {
		defer file.Close()
		if strings.Contains(scanner.Text(), "-Syu") {
			isFound = true
		}
		if isFound {
			pkgs += "\n" + scanner.Text()
		}
		if strings.Contains(scanner.Text(), "--needed") {
			isFound = false
			break
		}
	}
	if err = scanner.Err(); err != nil {
		log.Fatal(err)
	}

	_, err = exec.LookPath("yay")
	if err != nil {
		fmt.Println("Installing yay")

		cmd := exec.Command("git", "clone", "https://aur.archlinux.org/yay.git")
		cmd.Stdout = os.Stdout

		if err := cmd.Run(); err != nil {
			log.Fatal(err)
		}

		makepkg := exec.Command("makepkg", "-si")
		makepkg.Dir = "yay"
		makepkg.Stdout = os.Stdout
		makepkg.Stdin = os.Stdin

		if err := makepkg.Run(); err != nil {
			log.Fatal(err)
		}

	}

	yay := exec.Command(pkgs)
	yay.Stdout = os.Stdout
	yay.Stdin = os.Stdin
	if err := yay.Run(); err != nil {
		log.Fatal(err)
	}
}

package main

import (
	"fmt"
	"os"
	"strings"

	tea "github.com/charmbracelet/bubbletea"
	"github.com/angelocordon/kamaete/internal"
)

func main() {
	if len(os.Args) < 2 || os.Args[1] != "init" {
		fmt.Println("Usage: kamae init")
		fmt.Println("\nCommands:")
		fmt.Println("  init    Interactive application selection and installation")
		os.Exit(1)
	}

	// Load the manifest
	manifestPath := internal.GetDefaultManifestPath()
	manifest, err := internal.LoadManifest(manifestPath)
	if err != nil {
		fmt.Printf("Error loading manifest from %s: %v\n", manifestPath, err)
		os.Exit(1)
	}

	// Get app items from manifest
	apps := manifest.GetAppItems()
	if len(apps) == 0 {
		fmt.Println("No applications found in manifest")
		os.Exit(1)
	}

	// Check if we're in test mode (non-interactive)
	if len(os.Args) > 2 && os.Args[2] == "--test" {
		// Test mode: use default selections
		fmt.Println("--- Test Mode: Using default selections ---")
		testInstallation(apps)
		return
	}

	// Run the interactive UI
	m := internal.InitialModel(apps)
	p := tea.NewProgram(m, tea.WithAltScreen())

	finalModel, err := p.Run()
	if err != nil {
		fmt.Printf("Error running program: %v\n", err)
		os.Exit(1)
	}

	// Handle the final selection
	if model, ok := finalModel.(internal.Model); ok {
		handleInstallation(model, apps)
	}
}

func testInstallation(allApps []internal.AppItem) {
	var selectedApps []internal.AppItem
	
	// Use default selections (recommended apps)
	for _, app := range allApps {
		if app.Selected {
			selectedApps = append(selectedApps, app)
		}
	}

	if len(selectedApps) == 0 {
		fmt.Println("No applications selected. Exiting.")
		return
	}

	fmt.Printf("\n--- Installing the following applications (stub):\n\n")
	
	// Group by installation method for better output
	brewApps := []string{}
	brewCaskApps := []string{}
	masApps := []string{}

	for _, app := range selectedApps {
		switch app.App.Install {
		case "brew":
			brewApps = append(brewApps, app.App.ID)
		case "brew_cask":
			brewCaskApps = append(brewCaskApps, app.App.ID)
		case "mas":
			masApps = append(masApps, fmt.Sprintf("%s (ID: %s)", app.App.ID, app.App.MasID))
		}
		fmt.Printf("Installing %s... [stub]\n", app.App.Name)
	}

	fmt.Println("\n--- Installation Summary (stub) ---")
	
	if len(brewApps) > 0 {
		fmt.Printf("Homebrew packages: brew install %s\n", strings.Join(brewApps, " "))
	}
	
	if len(brewCaskApps) > 0 {
		fmt.Printf("Homebrew casks: brew install --cask %s\n", strings.Join(brewCaskApps, " "))
	}
	
	if len(masApps) > 0 {
		fmt.Printf("Mac App Store apps: %s\n", strings.Join(masApps, ", "))
	}

	fmt.Printf("\nTotal applications: %d\n", len(selectedApps))
	fmt.Println("Done!")
}

func handleInstallation(model internal.Model, allApps []internal.AppItem) {
	var selectedApps []internal.AppItem
	
	// Collect selected apps
	for i, app := range allApps {
		if model.Selected(i) {
			selectedApps = append(selectedApps, app)
		}
	}

	if len(selectedApps) == 0 {
		fmt.Println("No applications selected. Exiting.")
		return
	}

	fmt.Printf("\n--- Installing the following applications (stub):\n\n")
	
	// Group by installation method for better output
	brewApps := []string{}
	brewCaskApps := []string{}
	masApps := []string{}

	for _, app := range selectedApps {
		switch app.App.Install {
		case "brew":
			brewApps = append(brewApps, app.App.ID)
		case "brew_cask":
			brewCaskApps = append(brewCaskApps, app.App.ID)
		case "mas":
			masApps = append(masApps, fmt.Sprintf("%s (ID: %s)", app.App.ID, app.App.MasID))
		}
		fmt.Printf("Installing %s... [stub]\n", app.App.Name)
	}

	fmt.Println("\n--- Installation Summary (stub) ---")
	
	if len(brewApps) > 0 {
		fmt.Printf("Homebrew packages: brew install %s\n", strings.Join(brewApps, " "))
	}
	
	if len(brewCaskApps) > 0 {
		fmt.Printf("Homebrew casks: brew install --cask %s\n", strings.Join(brewCaskApps, " "))
	}
	
	if len(masApps) > 0 {
		fmt.Printf("Mac App Store apps: %s\n", strings.Join(masApps, ", "))
	}

	fmt.Printf("\nTotal applications: %d\n", len(selectedApps))
	fmt.Println("Done!")
}
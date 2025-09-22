package internal

import (
	"os"
	"path/filepath"

	"gopkg.in/yaml.v3"
)

// App represents a single application in the manifest
type App struct {
	Name    string `yaml:"name"`
	ID      string `yaml:"id"`
	Install string `yaml:"install"`
	MasID   string `yaml:"mas_id,omitempty"`
}

// Category represents a category of applications
type Category map[string][]App

// Manifest represents the complete application manifest
type Manifest struct {
	Recommended Category `yaml:"recommended"`
	Optional    Category `yaml:"optional"`
}

// AppItem represents an app with its selection state and metadata
type AppItem struct {
	App         App
	Category    string
	Priority    string // "recommended" or "optional"
	DisplayName string
	Selected    bool
}

// LoadManifest loads the manifest from the specified YAML file
func LoadManifest(manifestPath string) (*Manifest, error) {
	data, err := os.ReadFile(manifestPath)
	if err != nil {
		return nil, err
	}

	var manifest Manifest
	err = yaml.Unmarshal(data, &manifest)
	if err != nil {
		return nil, err
	}

	return &manifest, nil
}

// GetAppItems converts the manifest into a flat list of AppItem structs
// with recommended apps pre-selected
func (m *Manifest) GetAppItems() []AppItem {
	var items []AppItem

	// Process recommended apps
	for categoryName, apps := range m.Recommended {
		for _, app := range apps {
			displayName := app.Name + " (recommended)"
			items = append(items, AppItem{
				App:         app,
				Category:    categoryName,
				Priority:    "recommended",
				DisplayName: displayName,
				Selected:    true, // Pre-select recommended apps
			})
		}
	}

	// Process optional apps
	for categoryName, apps := range m.Optional {
		for _, app := range apps {
			displayName := app.Name + " (optional)"
			items = append(items, AppItem{
				App:         app,
				Category:    categoryName,
				Priority:    "optional",
				DisplayName: displayName,
				Selected:    false, // Optional apps are not pre-selected
			})
		}
	}

	return items
}

// GetDefaultManifestPath returns the default path to the manifest file
func GetDefaultManifestPath() string {
	// Try to find the manifest file relative to the executable
	execPath, err := os.Executable()
	if err == nil {
		// Try relative to executable
		manifestPath := filepath.Join(filepath.Dir(execPath), "..", "modules", "apps.yaml")
		if _, err := os.Stat(manifestPath); err == nil {
			return manifestPath
		}
	}

	// Try current working directory structure
	if _, err := os.Stat("modules/apps.yaml"); err == nil {
		return "modules/apps.yaml"
	}

	// Default fallback
	return "modules/apps.yaml"
}
package internal

import (
	"fmt"
	"strings"

	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
)

var (
	titleStyle = lipgloss.NewStyle().
			Bold(true).
			Foreground(lipgloss.Color("#7C3AED")).
			MarginBottom(1)

	categoryStyle = lipgloss.NewStyle().
			Bold(true).
			Foreground(lipgloss.Color("#059669")).
			MarginTop(1)

	selectedStyle = lipgloss.NewStyle().
			Foreground(lipgloss.Color("#10B981"))

	unselectedStyle = lipgloss.NewStyle().
			Foreground(lipgloss.Color("#6B7280"))

	helpStyle = lipgloss.NewStyle().
			Foreground(lipgloss.Color("#9CA3AF")).
			MarginTop(2)

	summaryStyle = lipgloss.NewStyle().
			Bold(true).
			Foreground(lipgloss.Color("#DC2626")).
			MarginTop(1)
)

type Model struct {
	apps     []AppItem
	cursor   int
	selected map[int]bool
	done     bool
}

// Selected returns whether the app at the given index is selected
func (m Model) Selected(index int) bool {
	return m.selected[index]
}

func InitialModel(apps []AppItem) Model {
	selected := make(map[int]bool)
	// Pre-select recommended apps
	for i, app := range apps {
		if app.Selected {
			selected[i] = true
		}
	}

	return Model{
		apps:     apps,
		selected: selected,
	}
}

func (m Model) Init() tea.Cmd {
	return nil
}

func (m Model) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	switch msg := msg.(type) {
	case tea.KeyMsg:
		switch msg.String() {
		case "ctrl+c", "q":
			return m, tea.Quit

		case "up", "k":
			if m.cursor > 0 {
				m.cursor--
			}

		case "down", "j":
			if m.cursor < len(m.apps)-1 {
				m.cursor++
			}

		case " ":
			// Toggle selection
			if m.selected[m.cursor] {
				delete(m.selected, m.cursor)
			} else {
				m.selected[m.cursor] = true
			}

		case "enter":
			// Finish selection
			m.done = true
			return m, tea.Quit
		}
	}

	return m, nil
}

func (m Model) View() string {
	if m.done {
		return ""
	}

	var b strings.Builder

	// Title
	b.WriteString(titleStyle.Render("kamae - Bootstrap Application Installer"))
	b.WriteString("\n\n")

	// Group apps by category for display
	categories := make(map[string][]AppItem)
	for _, app := range m.apps {
		categories[app.Category] = append(categories[app.Category], app)
	}

	currentIndex := 0

	// Render recommended apps first
	b.WriteString(categoryStyle.Render("RECOMMENDED APPLICATIONS"))
	b.WriteString("\n")

	for category, apps := range categories {
		hasRecommended := false
		for _, app := range apps {
			if app.Priority == "recommended" {
				hasRecommended = true
				break
			}
		}

		if hasRecommended {
			b.WriteString(fmt.Sprintf("\n  %s:\n", strings.Title(category)))
			for i, app := range m.apps {
				if app.Category == category && app.Priority == "recommended" {
					cursor := " "
					if m.cursor == i {
						cursor = ">"
					}

					checked := " "
					if m.selected[i] {
						checked = "✓"
					}

					style := unselectedStyle
					if m.selected[i] {
						style = selectedStyle
					}

					line := fmt.Sprintf("%s [%s] %s", cursor, checked, app.DisplayName)
					b.WriteString(style.Render("    "+line) + "\n")
					currentIndex++
				}
			}
		}
	}

	// Render optional apps
	b.WriteString(categoryStyle.Render("\nOPTIONAL APPLICATIONS"))
	b.WriteString("\n")

	for category, apps := range categories {
		hasOptional := false
		for _, app := range apps {
			if app.Priority == "optional" {
				hasOptional = true
				break
			}
		}

		if hasOptional {
			b.WriteString(fmt.Sprintf("\n  %s:\n", strings.Title(category)))
			for i, app := range m.apps {
				if app.Category == category && app.Priority == "optional" {
					cursor := " "
					if m.cursor == i {
						cursor = ">"
					}

					checked := " "
					if m.selected[i] {
						checked = "✓"
					}

					style := unselectedStyle
					if m.selected[i] {
						style = selectedStyle
					}

					line := fmt.Sprintf("%s [%s] %s", cursor, checked, app.DisplayName)
					b.WriteString(style.Render("    "+line) + "\n")
					currentIndex++
				}
			}
		}
	}

	// Help text
	b.WriteString(helpStyle.Render("\nNavigation: ↑/↓ or j/k to move, space to toggle, enter to install, q to quit"))

	// Selection summary
	selectedCount := len(m.selected)
	b.WriteString(summaryStyle.Render(fmt.Sprintf("\nSelected: %d applications", selectedCount)))

	return b.String()
}

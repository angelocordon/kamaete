.PHONY: setup build test lint format clean help

# Default target
all: build

# help: Show this help message
help:
	@echo "Available targets:"
	@echo "  setup    - Download Go modules and prepare development environment"
	@echo "  build    - Compile the kamae binary"
	@echo "  test     - Run all Go tests in the repository"
	@echo "  lint     - Run Go linters (requires golangci-lint to be installed)"
	@echo "  format   - Format Go source files using gofmt"
	@echo "  clean    - Remove build artifacts (bin/ directory)"
	@echo "  help     - Show this help message"

# setup: Download Go modules and prepare development environment
setup:
	@echo "Setting up development environment..."
	go mod tidy
	go mod download
	@echo "Setup complete! You can now run 'make build' to compile the binary."

# build: Compile the kamae binary
build:
	@echo "Building kamae binary..."
	go build -o bin/kamae ./cmd/kamae
	@echo "Binary created at ./bin/kamae"

# test: Run all Go tests in the repository
test:
	@echo "Running tests..."
	go test ./...

# lint: Run Go linters (requires golangci-lint to be installed)
lint:
	@echo "Running linters..."
	@if command -v golangci-lint >/dev/null 2>&1; then \
		golangci-lint run; \
	else \
		echo "golangci-lint not found. Install it with:"; \
		echo "  go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest"; \
		echo "For now, running basic go vet and fmt checks..."; \
		go vet ./...; \
		if [ -n "$$(gofmt -l .)" ]; then \
			echo "The following files need formatting:"; \
			gofmt -l .; \
			echo "Run 'make format' to fix formatting issues."; \
			exit 1; \
		fi; \
	fi

# format: Format Go source files using gofmt
format:
	@echo "Formatting Go source files..."
	gofmt -w .
	@echo "Formatting complete."

# clean: Remove build artifacts
clean:
	@echo "Cleaning build artifacts..."
	rm -rf bin/
	@echo "Clean complete."
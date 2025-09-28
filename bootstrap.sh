#!/bin/bash

echo -e "\nWelcome to kamaete bootstrap!"
echo "Please choose a workflow:"
echo "1) Install applications & tools"
echo "2) Set up dev environment"
echo "3) Configure user profile"
echo
echo "ctrl + c to exit."
echo

while true; do
  if ! read -r -p "Enter your choice [1-3]: " choice; then
    echo ""
    echo "This script requires interactive input."
    echo "Please run it directly instead of piping from curl:"
    echo ""
    echo "  curl -o bootstrap.sh https://raw.githubusercontent.com/angelocordon/kamaete/main/bootstrap.sh"
    echo "  chmod +x bootstrap.sh"
    echo "  ./bootstrap.sh"
    exit 1
  fi
  case $choice in
    1)
      echo -e "\n--- Installing applications & tools ---"
      echo "Pretending to install Homebrew, VSCode, Docker, etc..."
      echo "Done (stub)!"
      break
      ;;
    2)
      echo -e "\n--- Setting up dev environment ---"
      echo "Pretending to create ~/Development, configure git, set up Github CLI, etc..."
      echo "Done (stub)!"
      break
      ;;
    3)
      echo -e "\n--- Configuring user profile ---"
      echo "Pretending to download profile, set wallpaper, etc..."
      echo "Done (stub)!"
      break
      ;;
    *)
      echo "Please enter 1, 2, or 3."
      ;;
  esac
done

echo -e "\nBootstrap finished! Re-run to try another workflow."
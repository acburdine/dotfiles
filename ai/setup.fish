set -l DIR (dirname (status --current-filename))
source "$DIR/../fish/functions/read_confirm.fish"

# prompt user to ask if AI tooling (claude/codex) should be installed, and if so set them up
if read_confirm "Do you want to set up AI tooling (claude/codex)?"
    then
    echo "installing claude"
    curl -fsSL https://claude.ai/install.sh | bash
    echo "installing codex"
    curl -fsSL https://chatgpt.com/codex/install.sh | sh
else
    echo "skipping AI tooling setup"
end

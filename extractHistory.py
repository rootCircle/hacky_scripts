import os
import re

fish_regex = r"^- cmd: (.*)$"
fish_regex = re.compile(fish_regex, re.MULTILINE)

filters_regex = []

filters_regex.append(
    r"(^(cargo run|cargo clippy|cargo check|cargo init|cargo add|cargo build|RUST_BACKTRACE=1|git commit|git add|git push|git restore|git remove|git status|git log|git remote|git pull|git branch|git checkout|git diff|pacman -Ss|pacman -Q[s]?|yay -Ss|yay -Q[s]?|paru -Ss|paru -Q[s]?|java|javac|python|python3|valgrind|gcc|g\+\+|make|gdb|mysql -u|xilinx|ise|xxd|htop|btop|top|man|help|tldr|festival|espeak|google_speak|tgpt|cd|which|lynx|powertop|viu|ranger|whereis|lspci|lsmod|lsusb|eos-welcome|ip|calc|open|neofetch|glxinfo|speak|strings|c|clear|time|update|reset|fg|cowsay|banner|file|stat|gnuchess|gnumeric|du|dust|kitty|code|diff|ls|ll|fd|rg|touch|locale|bash|zsh|history|fish|starship|rm|tree|ping)( .*)?$)|(.* (--help|-h|-V|-v|--version)$)|(^(echo|cat) [^\|\s]*$)\n"
)
filters_regex.append(r"\n{2,}")
filters_regex.append(r"\\n")

alias_regex = r"^((?:alias|set|abbr) .*)"
alias_regex = re.compile(alias_regex, re.MULTILINE)

pac_man_regex = r"(pacman|paru|yay)(?=.* -S(?: .*|$)) ?(.*)(?: -S)(?: |$)(.*)$"
pac_man_regex = re.compile(pac_man_regex, re.MULTILINE)

for i in range(len(filters_regex)):
    filters_regex[i] = re.compile(filters_regex[i], re.MULTILINE | re.IGNORECASE)


def main():
    user = run_command(f'sh -c "echo $USER"').strip()

    ZSH_HISTORY_FILE = [f"/home/{user}/.zhistory", f"/home/{user}/.zsh_history"]
    BASH_HISTORY_FILE = f"/home/{user}/.bash_history"
    FISH_HISTORY_FILE = [
        f"/home/{user}/.local/share/fish/fish_history",
        f"/home/{user}/.config/fish/fish_history",
    ]

    history_all = (
        read_shell_history(BASH_HISTORY_FILE)
        + "\n"
        + read_shell_history(ZSH_HISTORY_FILE)
        + "\n"
        + get_fish_history(FISH_HISTORY_FILE)
    )

    history_all = filters_regex[0].sub("", history_all)
    history_all = filters_regex[1].sub(r"\n", history_all)
    history_all = filters_regex[2].sub(r"\n", history_all)

    make_sh_file("\n".join(alias_regex.findall(history_all)), "alias_set_abbr.sh")
    history_all = alias_regex.sub("", history_all)
    history_all = filters_regex[1].sub(r"\n", history_all)

    pac_man_commands = pac_man_regex.findall(history_all)

    pm = ["pacman", "paru", "yay"]
    pm_commands = []

    pm_commands.append(f"{pm[0]} -Sq")
    pm_commands.append(f"{pm[1]} -Sq")
    pm_commands.append(f"{pm[2]} -Sq")

    for comm in pac_man_commands:
        pm_pos = pm_commands.index(comm[0])
        if pm_pos != -1:
            pm_commands[pm_pos] += f" {comm[1]} {comm[2]}"

    print(pm_commands)
    # print(history_all)


def make_sh_file(CONTENT, filename):
    if not os.path.exists("output/"):
        os.makedirs("output")

    with open(f"output/{filename}", "w") as f:
        f.write("#! /usr/bin/bash\n")
        f.write(CONTENT)

        print("File written successfully!")


# print(output)


def run_command(command):
    try:
        output = os.popen(command).read()
        if not output:
            print("Can't read Value")
        return output
    except Exception as err:
        print(f"Error : {err}")
        return False


def read_shell_history(HISTORY_FILE):
    if isinstance(HISTORY_FILE, (list, tuple)):
        output = ""

        for hist_file in HISTORY_FILE:
            temp = read_shell_history(hist_file)
            if temp:
                output += temp

        return output

    if os.path.exists(HISTORY_FILE):
        with open(HISTORY_FILE, "r") as f:
            return f.read()

    return False


def get_fish_history(HISTORY_FILE):
    HISTORY = read_shell_history(HISTORY_FILE)
    result = fish_regex.findall(HISTORY)
    return "\n".join(result)


if __name__ == "__main__":
    main()

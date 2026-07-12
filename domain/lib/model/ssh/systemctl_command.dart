enum SystemctlCommand {
    start(command: "start"),
    stop(command: "stop"),
    restart(command: "restart");

    final String command;
    const SystemctlCommand({required this.command});
}
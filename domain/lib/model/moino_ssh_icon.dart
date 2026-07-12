enum MoinoSshIcon {
    admin(id: 1, searchTags: "admin root security shield superuser"),
    public(id: 2, searchTags: "public world earth global network"),
    user(id: 3, searchTags: "user profile account person human"),
    web(id: 4, searchTags: "web website internet browser http"),
    database(id: 5, searchTags: "database sql storage data db"),
    mail(id: 6, searchTags: "mail email inbox message post"),
    storage(id: 7, searchTags: "storage drive disk harddrive files"),
    compute(id: 8, searchTags: "compute cpu processor server machine vps"),
    analytics(id: 9, searchTags: "analytics stats charts graph metrics"),
    unknown(id: 10, searchTags: "unknown help question info mystery"),
    terminal(id: 11, searchTags: "terminal console shell cli command prompt"),
    cloud(id: 12, searchTags: "cloud aws azure gcp provider remote"),
    security(id: 13, searchTags: "lock secure password private ssh key encrypted"),
    container(id: 14, searchTags: "container docker podman kubernetes k8s box"),
    monitoring(id: 15, searchTags: "activity status health heartbeat pulse live monitoring"),
    network(id: 16, searchTags: "network topology infrastructure connection nodes hub"),
    server(id: 17, searchTags: "server rack hardware datacenter baremetal"),
    script(id: 18, searchTags: "script code bash python configuration settings config"),
    firewall(id: 19, searchTags: "firewall wall protection blocking filter security"),
    backup(id: 20, searchTags: "backup archive zip save restore history"),
    genericFile(id: 21, searchTags: "file document generic data"),
    text(id: 22, searchTags: "text txt document note notes pdf portable format adobe"),
    image(id: 23, searchTags: "image picture photo png jpg jpeg svg"),
    video(id: 24, searchTags: "video movie mp4 avi film media"),
    audio(id: 25, searchTags: "audio music mp3 wav sound track"),
    archive(id: 26, searchTags: "archive zip rar tar compressed backup"),
    code(id: 27, searchTags: "code source script js py dart programming"),
    spreadsheet(id: 28, searchTags: "spreadsheet excel csv sheet table xlsx"),
    log(id: 29, searchTags: "log journal history events output diagnostic");

    final int id;
    final String searchTags;

    const MoinoSshIcon({
        required this.id,
        required this.searchTags,
    });

    String get label => name[0].toUpperCase() + name.substring(1);

    static MoinoSshIcon? findById(int? id) {
        if (id == null) return null;
        try {
            return MoinoSshIcon.values.firstWhere((icon) => icon.id == id);
        } catch (_) {
            return null;
        }
    }

    static List<MoinoSshIcon> search(String query) {
        final lowercaseQuery = query.toLowerCase();
        return MoinoSshIcon.values.where((icon) {
            return icon.name.contains(lowercaseQuery) ||
                icon.searchTags.contains(lowercaseQuery);
        }).toList();
    }
}
#include <err.h>
#include <mntent.h>
#include <string.h>
#include <unistd.h>

int main(int argc, char *argv[])
{
	char ini_conf_file[] = "/etc/frp_.ini";
	char toml_conf_file[] = "/etc/frp_.toml";
	size_t prog_path_len = strlen(argv[1]);
	ini_conf_file[strlen(ini_conf_file) - 5] = argv[1][prog_path_len - 1];
	toml_conf_file[strlen(toml_conf_file) - 6] = argv[1][prog_path_len - 1];

	struct mntent *ent;
	FILE *fp = setmntent("/proc/mounts", "r");
	if (fp == NULL) {
		err(1, "/proc/mounts");
	}

	short toml_mount_found = 0;
	while ((ent = getmntent(fp))!= NULL) {
		if (strcmp(ent->mnt_dir, ini_conf_file) == 0) {
			toml_mount_found = 1;
			break;
		}
	}

	if (toml_mount_found == 0 && access(ini_conf_file, F_OK) == 0) {
		for (int i = 2; i < argc; ++i) {
			if (strcmp(argv[i], toml_conf_file) == 0) {
				argv[i] = ini_conf_file;
				break;
			}
		}
	}

	char **cmdargv = &argv[2];
	execvp(argv[1], cmdargv);
	err(1, "%s", argv[1]);

	return 1;
}

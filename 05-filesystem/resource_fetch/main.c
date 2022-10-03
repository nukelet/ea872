#include <stdio.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>

enum http_response_code {
    /* Imaginary response code to satisfy the assignment requirements */
    HTTP_RESPONSE_OK = 0,  

    HTTP_RESPONSE_FORBIDDEN = 403,
    HTTP_RESPONSE_NOT_FOUND = 404,
};

void _print_file_contents(int fd)
{
    char *buf = malloc(4096);
    int bytes;
    do {
        bytes = read(fd, buf, 4096);
        if (bytes < 0) {
            fprintf(stderr, "Error (%d) reading resource\n", bytes);
            return;
        }
        write(1, buf, bytes);
    } while (bytes != 0);

    write(1, "\n", 1);

    fflush(stdout);
}

enum http_response_code server_fetch_resource(char *webspace_path, char *resource_path)
{
    size_t buf_size = strlen(webspace_path) + strlen(resource_path) + 2;
    char *path = malloc(buf_size);
    strncat(path, webspace_path, buf_size);
    strncat(path, "/", buf_size);
    strncat(path, resource_path, buf_size);

    printf("%s\n", path);

    struct stat statbuf;
    int err = stat(path, &statbuf);
    if (err) {
        return HTTP_RESPONSE_NOT_FOUND;
    }

    /* check read permissions for others */    
    if (!(statbuf.st_mode & S_IROTH)) {
        return HTTP_RESPONSE_FORBIDDEN;
    }

    /* check if fd points to a regular file */
    if (S_ISREG(statbuf.st_mode)) {
        int fd = open(path, O_RDONLY);
        _print_file_contents(fd);
        close(fd);
        return HTTP_RESPONSE_OK;
    }

    /* in case it's not a directory with execute permissions */
    if (!(S_ISDIR(statbuf.st_mode) && (statbuf.st_mode & S_IXOTH))) {
        return HTTP_RESPONSE_FORBIDDEN;
    }

    int dirfd = open(path, O_RDONLY);

    /* check if either index.html or welcome.html exist */
    struct stat index_statbuf, welcome_statbuf;
    int index_ret = fstatat(dirfd, "index.html", &index_statbuf, 0);
    int welcome_ret = fstatat(dirfd, "welcome.html", &index_statbuf, 0);
    if (index_ret && welcome_ret) {
        return HTTP_RESPONSE_NOT_FOUND;
    }

    /* check if neither index.html or welcome.html have read permissions for others */
    int index_executable = index_statbuf.st_mode & S_IROTH;
    int welcome_executable = welcome_statbuf.st_mode & S_IROTH;
    if (!(index_executable || welcome_executable)) {
        return HTTP_RESPONSE_FORBIDDEN;
    }

    int fd;
    if ((fd = openat(dirfd, "index.html", O_RDONLY)) > 0) {
        _print_file_contents(fd);
    } else if ((fd = openat(dirfd, "welcome.html", O_RDONLY)) > 0) {
        _print_file_contents(fd);
    }

    return HTTP_RESPONSE_OK;
}

int main(int argc, char **argv)
{
    if (argc != 3) {
        fprintf(stderr, "usage: resource_fetch <path-to-webspace> <path-to-resource>\n");
        return -EINVAL;
    }
    printf("retval: %d\n",
        server_fetch_resource(argv[1], argv[2]));

    return 0;
}
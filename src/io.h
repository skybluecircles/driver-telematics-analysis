int fget_point_c
(
    struct point_c * pt,
    FILE *fh,
    int line_no
);

int fgetd
(
    double *d,
    FILE *fh
);

char *fgets_s
(
    char *line,
    int size,
    FILE *fh
);

double strtod_s
(
    char *nptr,
    char *endptr
);

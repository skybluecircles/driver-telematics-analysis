struct point_c {
    double x;
    double y;
    int   ok;
};

struct point_p {
    double radius;
    double azimuth;
    int    ok;
};

struct point_c l_to_c ( char * line, char ifs );
struct point_p c_to_p ( struct point_c c );
struct point_p rotate ( struct point_p p, double rotation );
struct point_c p_to_c ( struct point_p p );
double calculate_rotation ( struct point_p hb ); 

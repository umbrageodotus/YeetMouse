 // Define undefined defines to avoid any issues for older config versions

#ifndef CC_DATA_AGGREGATE
#define CC_DATA_AGGREGATE
#endif

#ifndef MOTIVITY
#define MOTIVITY 1.5
#endif

#ifndef MOTIVITY
#define SENSITIVITY_Y 1.0
#endif

#ifndef RATIO_YX
#ifdef SENSITIVITY_Y
#define RATIO_YX ((float)SENSITIVITY_Y / SENSITIVITY)
#else
#define RATIO_YX 1
#endif
#endif
#include <iostream>
#include <cstdint>
#include <cmath>

union BinaryToFloat {
    uint32_t binary;  // 32-bit unsigned integer to hold binary value
    float f;          // 32-bit float
};

int main() {
    BinaryToFloat converter;
    
    // Assign binary value representing float (for example, 0x40490FDB is approximately 3.14159)
    converter.binary = 0x40490FDB;
    
    while ( scanf("%x", &converter.binary) == 1 ) {
        uint32_t n = floor(log2(converter.f));
        printf("%08x\n", n);
    }
    return 0;
}
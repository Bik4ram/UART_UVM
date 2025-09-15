package uart_pkg;
typedef enum logic [1:0] {
PARITY_NONE = 2'b00,
PARITY_EVEN = 2'b01,
PARITY_ODD = 2'b10
} parity_e;
endpackage : uart_pkg

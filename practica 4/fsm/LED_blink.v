`timescale 1ns/100ps
module LED_blink (input wire CLK,
                    output wire LED);
    // Declaración de señales
    reg [12:0] data = 0;
    // Asignación: bit 24 de data se asigna a la salida LED
    assign LED = data[12];
    // Contador: incrementa con cada flanco de subida del reloj
    always@(posedge CLK) begin
        data <= data + 1;
    end
endmodule
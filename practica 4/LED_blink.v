`timescale 1ns/100ps
module LED_blink (input wire CLK,
                    output wire LED7, 
                    output wire LED6,
                    output wire LED5, 
                    output wire LED4,
                    output wire LED3, 
                    output wire LED2,
                    output wire LED1,
                    output wire LED0,
                    input wire BUTTON);
                    
    // Declaración de señales
    reg [24:0] data = 0;
    // Asignación: bit 24 de data se asigna a la salida LED
    assign LED7 = data[24];
    assign LED6 = data[23];
    assign LED5 = data[22];
    assign LED4 = data[21];
    assign LED3 = data[20];
    assign LED2 = data[19];
    assign LED1 = data[18];
    assign LED0 = data[17];

    // Contador: incrementa con cada flanco de subida del reloj
    always@(posedge CLK)
        begin
            if(BUTTON==1)
                data<=0;
            else
                data <= data + 1;
    end
endmodule
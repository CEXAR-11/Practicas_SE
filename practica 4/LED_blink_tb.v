`timescale 1ns/100ps
module LED_blink_tb ();
    reg clk;
    wire led7;
    wire led6;
    wire led5;
    wire led4;
    wire led3;
    wire led2;
    wire led1;
    wire led0;
    wire button;

    // Generamos reloj
    // Periodo = 5 * timescale = 5 * 1ns = 5ns
    localparam CLOCK_PERIOD = 5;

    // Inicialmente está a 0
    initial clk = 1'b0;
    // Cambio valor de clk cada 5ns
    always #CLOCK_PERIOD clk = ~clk;

    // Boton
    reg but_reg;
    initial but_reg = 0;
    assign button = but_reg;

    always #500 but_reg = ~but_reg;

    initial
        begin
            // Vuelca formas de onda en el fichero dump.vcd
            $dumpfile("LED_blink_tb.vcd");
            $dumpvars(0, LED_blink_tb);
            #25000000; // Espera hasta tiempo 50000ns
            $display(" End of simulation time is %d", $time);
            $display("Ended without errors.");
            $finish; // Acaba la simulación            
        end

    // Instanciamos el modulo que vamos a simular
    LED_blink DUT (.CLK(clk),
                    .LED7(led7),
                    .LED6(led6),
                    .LED5(led5),
                    .LED4(led4),
                    .LED3(led3),
                    .LED2(led2),
                    .LED1(led1),
                    .LED0(led0),
                    .BUTTON(button));
endmodule
`timescale 1ns/100ps
module fsm_tb();

    reg clk;
    reg Reset;

    // botones
    wire A;
    wire B;
    
    // Outputs
    wire LED7;
    wire LED6;
    wire LED5; 
    wire LED4;
    wire LED3; 
    wire LED2;
    wire LED1;
    wire LED0;

    //wire [1:0] Status;

    // Generamos reloj
    // Periodo = 5 * timescale = 5 * 1ns = 5ns
    localparam CLOCK_PERIOD = 5;
    
    // Inicialmente está a 0
    initial clk = 1'b0;

    // Boton
    reg but_A;
    reg but_B;

    initial but_A = 0;
    initial but_B = 0;

    assign A = but_A;
    assign B = but_B;

    //always #300 but_A = ~but_A;
    //always #200 but_B = ~but_B;

    // Cambio valor de clk cada 5ns
    always #CLOCK_PERIOD clk = ~clk;
    
    initial
        begin
        // Vuelca formas de onda en el fichero dump.vcd
        $dumpfile("fsm_tb.vcd");
        $dumpvars(0 , fsm_tb);
        #50;
        // DOBLE PULSACIÓN: CAMBIA DE ESTADO (ESPERA -> PROGRAMACIÓN)
        but_A = 1;
        but_B = 1;
        #10; // El pulso debe ser de mínimo 10 ciclos para asegurar que siempre pillará un flnaco de subida del reloj
        but_B = 0;
        but_A = 0;
        #50;
        // PULSO DE BOTÓN A (CONT = 1)
        but_A = 1;
        #10;
        but_A = 0;
        #50;
        // PULSO DE BOTÓN B: CAMBIO DE ESTADO (PROGRAMACIÓN -> EJECUCIÓN)
        but_B = 1;
        #10;
        but_B = 0;
        #1500000; // Espera 1 s + ejecución del Comando 1...
        // DOBLE PULSACIÓN: CAMBIA DE ESTADO (ESPERA -> PROGRAMACIÓN)
        but_A = 1;
        but_B = 1;
        #10;
        but_B = 0;
        but_A = 0;
        #10;
        // PULSO DE BOTÓN A (CONT = 1)
        but_A = 1;
        #10;
        but_A = 0;
        #50;
        // PULSO DE BOTÓN A (CONT = 2)
        but_A = 1;
        #10;
        but_A = 0;
        #50;
        // PULSO DE BOTÓN B: CAMBIO DE ESTADO (PROGRAMACIÓN -> EJECUCIÓN)
        but_B = 1;
        #10;
        but_B = 0;
        #200;
        $display(" End of simulation time is %d", $time);
        $finish; // Acaba la simulación
    end

    // Instanciamos el modulo que vamos a simular
    fsm DUT (.Clock(clk),
            .Reset(Reset),
            .A(A),
            .B(B),
            .LED7(LED7),
            .LED6(LED6),
            .LED5(LED5),
            .LED4(LED4),
            .LED3(LED3),
            .LED2(LED2),
            .LED1(LED1),
            .LED0(LED0));
            //.Status(Status));
endmodule
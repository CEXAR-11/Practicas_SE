////////////////////////////////////////////////////////////////////////////////
module fsm (
// Inputs
 input wire Clock ,
 input wire Reset ,
 input wire A,
 input wire B,
 
 output wire LED7, 
 output wire LED6,
 output wire LED5, 
 output wire LED4,
 output wire LED3, 
 output wire LED2,
 output wire LED1,
 output wire LED0
 );

 // State Encoding
 localparam STATE_Initial = 2'd0,
 STATE_1 = 2'd1,
 STATE_2 = 2'd2,
 STATE_3 = 2'd3;
 
 // Leds Encoding
 reg [24:0] data = 0;
 reg [1:0] Status = 0;
 reg [0:0] FLAG = 0;
 reg [0:0] FLAG2 = 0;

 // Asignación: bit 24 de data se asigna a la salida LED
 assign LED7 = data[24];
 assign LED6 = data[23];
 assign LED5 = data[22];
 assign LED4 = data[21];
 assign LED3 = data[20];
 assign LED2 = data[19];
 assign LED1 = data[18];
 assign LED0 = data[17];
 
 // Declaración de herramientas para señales
 reg [1:0] ERROR = 0;
 reg [1:0] EXECUTE = 0;
 reg [2:0] Cont = 0;

  wire ONESEC;

  // State reg Declarations
 reg [1:0] CurrentState ;
 reg [1:0] NextState ;

 // Declaración de señales
  reg [12:0] data_C1 = 0;

 oneSec OneSecond(
        .Clock(Clock),
        .START(STATE_3), // el inicio del modo 3 es lo que triggerea la espera de un segundo
        .END(ONESEC) // almacena la señal de completado
 );

 /*LED_blink LB(
        .CLK(Clock),
        .LED7(LED7), 
        .LED6(LED6),
        .LED5(LED5), 
        .LED4(LED4),
        .LED3(LED3), 
        .LED2(LED2),
                    output wire LED1,
                    output wire LED0,
                    input wire BUTTON
);*/

// Synchronous State - Transition always@ ( posedge Clock ) block
always@ ( posedge Clock ) begin

        if ( Reset ) CurrentState <= STATE_Initial ;
        else CurrentState <= NextState;

        // INCREMENTO DEL CONTADOR (1 POR PULSACIÓN)
        if(CurrentState == STATE_2 & A) begin
                if(Cont!=4) begin
                        Cont<=Cont+1;
                end else begin
                        ERROR = 1;
                end
        end

        if(CurrentState == STATE_3 & NextState == STATE_3) begin // si se está en el modo ejecución
                if (OneSecond.END) begin // cuando haya pasado un segundo
                        case (Cont)
                                // COMANDO 1
                                1: begin
                                        data[24:18] = 7'b0000000; // se apagan el resto de leds.
                                        data[17] = data_C1[12]; // se cambia el registro donde se encuentra el LED
                                        data_C1 <= data_C1 + 1; // el LED0 parpadeará según el ejercicio 2.1.
                                end
                                // COMANDO 2
                                2: begin
                                        if(data[24:17] != 8'b00000000) begin
                                                data[24:17] = 8'b00000000;
                                        end else begin
                                                data[24:17] = 8'b11111111;
                                        end
                                end
                                // COMANDO 3
                                3: begin
                                        data <= data + 1;
                                end
                                // COMANDO 4
                                4: begin
                                        if(!A & B) begin // reset del contador
                                                data = 0;
                                        end
                                end
                                default : begin
                                        NextState = STATE_Initial;
                                end
                        endcase
                end
        end

// LÓGICA DE LOS BOTONES PARA A Y B (lo del pulse y to eso)***********************************

end

 assign LED7 = data[24];
 assign LED6 = data[23];
 assign LED5 = data[22];
 assign LED4 = data[21];
 assign LED3 = data[20];
 assign LED2 = data[19];
 assign LED1 = data[18];
 assign LED0 = data[17];

// Conditional State - Transition always@ ( * ) block
 always@ ( * ) begin
        NextState = CurrentState ;
        case ( CurrentState )
                STATE_Initial : begin
                        data[24:17] = 8'b11111111; // Todos los leds encendios.
                        NextState = STATE_1 ;
                end
                STATE_1 : begin // MODO ESPERA
                        if (A & B) begin // cambio al Estado 2
                                data[24:17] = 8'b11000011; // Se encienden los LEDs 0, 1, 6 y 7.
                                NextState = STATE_2;
                        end
                end
                STATE_2 : begin // MODO PROGRAMACIÓN
                        if(!A & B) begin // cambio al Estado 3 o al 1
                                if(ERROR == 0 & Cont > 0) begin
                                        NextState = STATE_3 ;
                                end else begin
                                        data[24:17] = 8'b11111111; // Todos los leds encendios.
                                        Cont=0;
                                        NextState = STATE_1;
                                end
                                ERROR=0;
                        end                        
                end
                STATE_3 : begin // MODO EJECUCIÓN
                        if (A && B) begin // cambio al Estado 2 (fin ejecución, modo programación)
                                Cont=0;
                                data[24:17] = 8'b11000011; // Se encienden los LEDs 0, 1, 6 y 7.
                                NextState = STATE_2;
                        end
                end
                default: begin
                        NextState =STATE_Initial ;
                end
        endcase
 end


 endmodule

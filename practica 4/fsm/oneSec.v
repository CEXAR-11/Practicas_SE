////////////////////////////////////////////////////////////////////////////////
module oneSec (
// Inputs
 input wire Clock ,
 input wire START,
// Outputs
 output wire END
 );

 reg started_ = 0;
 reg end_ = 0;
 assign END = end_;

 reg [17:0] Cont = 0;

// Synchronous State - Transition always@ ( posedge Clock ) block
always@ (posedge Clock) begin

        if(START && started_==0) begin
                started_ = 1;
                end_ = 0;
        end

        if(started_ == 1 && !end_) begin
                if(Cont<120000)begin
                        Cont<=Cont+1;
                end else begin
                        end_ = 1;
                end

        end

        if(!START && Cont>120000) begin
                started_=0;
                end_ = 0;
        end

// LÓGICA DE LOS BOTONES PARA A Y B (lo del pulse y to eso)***********************************

end

endmodule

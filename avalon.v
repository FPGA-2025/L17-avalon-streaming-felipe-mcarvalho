module avalon (
    input wire clk,
    input wire resetn,
    output reg valid,
    input wire ready,
    output reg [7:0] data
);

    parameter IDLE      = 3'd0;
    parameter ENVIAR_4  = 3'd1;
    parameter ENVIAR_5  = 3'd2;
    parameter ENVIAR_6  = 3'd3;
    parameter AGUARDA_5 = 3'd4;
    parameter AGUARDA_6 = 3'd5;
    parameter FIM       = 3'd6;

    reg [2:0] estado, proximo_estado;

    // Transicao de estados
    always @(posedge clk or negedge resetn) begin
        if (!resetn)
            estado <= IDLE;
        else
            estado <= proximo_estado;
    end

    // Proximo estado
    always @(*) begin
        proximo_estado = estado;
        case (estado)
            IDLE:       if (ready) proximo_estado = ENVIAR_4;
            ENVIAR_4:   proximo_estado = ready ? ENVIAR_5 : AGUARDA_5;
            AGUARDA_5:  if (ready) proximo_estado = ENVIAR_5;
            ENVIAR_5:   proximo_estado = ready ? ENVIAR_6 : AGUARDA_6;
            AGUARDA_6:  if (ready) proximo_estado = ENVIAR_6;
            ENVIAR_6:   proximo_estado = FIM;
            FIM:        proximo_estado = FIM;
        endcase
    end

    // Saidas
    always @(*) begin
        valid = 0;
        data = 8'd0;
        case (estado)
            ENVIAR_4: begin valid = 1; data = 8'd4; end
            ENVIAR_5: begin valid = 1; data = 8'd5; end
            ENVIAR_6: begin valid = 1; data = 8'd6; end
        endcase
    end

endmodule

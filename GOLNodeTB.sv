
module testbench;

    logic clk;
    logic reset;
    logic [8:0] TestTable;
    logic out, out_expected;
    logic [31:0] vectornum, errors;
    logic [9:0] testvectors[10000:0];
    
    GOLNode dut(TestTable, out);

    always
        begin
            clk = 1; #5; clk = 0; #5;
        end

    initial
        begin
            $readmemb("GOLNodeTV.tv", testvectors);
            vectornum = 0; errors = 0;
            reset = 1; #20; reset = 0;
        end

    always@(negedge clk)
    begin
        {TestTable, out_expected} = testvectors[vectornum];
    end


    always@(posedge clk)
    begin
         if (~reset) begin
            if (out !== out_expected) begin
                $display("Error: inputs = %b", TestTable);
                $display(" outputs = %b (%b expected)", out, out_expected);
                errors = errors + 1;
            end else begin
                $display("Pass: inputs = %b", {TestTable});
                $display(" outputs = %b", out);
            end
            vectornum = vectornum + 1;
            if (testvectors[vectornum] === 10'bx) begin
                $display("%d tests completed with %d errors", vectornum, errors);
                $finish;
            end
        end
    end
endmodule

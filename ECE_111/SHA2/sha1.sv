

module sha1(input logic clk, reset_n, start,
	input logic [31:0] message_addr, size, output_addr,
	output logic done, mem_clk, mem_we,
	output logic [15:0] mem_addr,
	output logic [31:0] mem_write_data,
	input logic [31:0] mem_read_data);

enum logic [2:0] {IDLE=3'b000, READ_1=3'b001,  READ_2= 3'b010, COMPUTE=3'b011, WRITE=3'b100} state;

logic [31:0] temp;    

	logic [7:0] number_of_words;   //number of words left in a 512 blocks

	logic [7:0] count;

    //Logic [7:0] count_w;

    logic [31:0] message_size; //store the message size(in bits)

    logic [15:0] number_of_blocks; //record how many blocks need to be calculated 

    logic [8:0] number_of_last_bytes; //used for the last 512-bit block

    logic [31:0] read_addr;

    logic [31:0] write_addr;

    logic [31:0] h[5]; 

    logic [31:0] w[16]; 

    logic pad_zero,pad_one; //indicate that we are processing the last block

    logic block_complete; //indicate when one block processing is finished

    logic [159:0] hash_code;  //store the hash op at each iteration
    logic [31:0] hash_code_out[5];
    assign mem_clk = clk;
    // Select the memory address based on the mem_we(the indicate bit)
    assign mem_addr = (mem_we == 0)? read_addr[15:0] : write_addr[15:0];

    assign h[0] = hash_code[159:128];
    assign h[1] = hash_code[127:96];
    assign h[2] = hash_code[95:64];
    assign h[3] = hash_code[63:32];
    assign h[4] = hash_code[31:0];
    //assign done = (count == 0)? 1 : 0; // assign the value of done based on the count

    always_ff @(posedge clk or negedge reset_n) begin
    	if(!reset_n) begin
    		state <= IDLE;
    	end else begin
    		case(state)
    			IDLE:
    			begin
    				if(start && opcode == 0) begin
              //$display("message_addr = %x, output_addr=%x", message_addr, output_addr);
              state <= READ_1; 
            //calculate number of blocks

            message_size <= size << 3;  

            number_of_blocks <= determine_num_blocks(size);
            $display("message size in byte: %d", size);
            $display("number_of_blocks is %d", determine_num_blocks(size));
            //assign the mesage address and output address
            read_addr <= message_addr;
            
            write_addr <= output_addr;
            
            mem_we <= 0;    //set to read

            pad_zero <= 0;

            pad_one <= 0;
            
            block_complete <= 0;  //set indicate bit to false

            count <= 8'd0;
            
            number_of_words <= 8'd0;
            
            number_of_last_bytes <= size % 64;    

            //initialize the value of h0,h1,h2,h3,h4
            hash_code_out[0] <= 32'h67452301;
            hash_code_out[1] <= 32'hefcdab89;
            hash_code_out[2] <= 32'h98badcfe;
            hash_code_out[3] <= 32'h10325476;
            hash_code_out[4] <= 32'hc3d2e1f0;
            hash_code <= 160'h67452301efcdab8998badcfe10325476c3d2e1f0;

        end else if (block_complete) begin
            	//before we start to process the next block, we reset the counter and indicate bit
            	$display("Preparing for next block");
          		$display("hash_code out in IDLE state: %x%x%x%x%x", hash_code_out[0],hash_code_out[1],hash_code_out[2],hash_code_out[3],hash_code_out[4]);
            	count <= 0;
            	hash_code <= {hash_code_out[0],hash_code_out[1],hash_code_out[2],hash_code_out[3],hash_code_out[4]} ;
            	block_complete <= 0;

            	number_of_words <= 0;

            	state <= READ_1;

            	mem_we <= 0;
            end
        end

        READ_1: begin

        	state <= READ_2;
          read_addr <= read_addr + 1;

        end

        READ_2:
        begin
        	if(pad_one && number_of_words < 16) begin 

        		if(pad_zero) begin
        			pad_zero_and_message_size(message_size,number_of_words);
        			state <= COMPUTE;
        			count <= 0;
        		end else if((number_of_last_bytes/4) > 0) begin
        			w[number_of_words] <= changeEndian(mem_read_data);
        			number_of_last_bytes <= number_of_last_bytes - 4; 
               	//$display("READ: %x WITH IDX: %d", changeEndian(mem_read_data), number_of_words);
               	read_addr <= read_addr + 1;
               end else begin
                	//$display("Number of last bytes should be 0, but is %d", number_of_last_bytes);
                    //$display("READ: %x", mem_read_data);
                	if (number_of_last_bytes == 1) begin      //pad 1 at the end
                		w[number_of_words]<=((changeEndian(mem_read_data) & 32'hFF000000) | 32'h00800000);
                	end else if (number_of_last_bytes == 2) begin 
                		w[number_of_words]<=((changeEndian(mem_read_data) & 32'hFFFF0000) | 32'h00008000);
                	end else if (number_of_last_bytes == 3) begin
                		w[number_of_words]<=((changeEndian(mem_read_data) & 32'hFFFFFF00) | 32'h00000080);
                	end else if (number_of_last_bytes == 0) begin
                		w[number_of_words]<= 32'h80000000;
                	end
                	pad_zero <= 1;
                end
                number_of_words <= number_of_words + 1;
          end else if(number_of_words<16) begin  //the number case: read data for 16 times 
                  w[number_of_words] <= changeEndian(mem_read_data); //get data from memory and store in w
                  //$display("READ: %x WITH IDX: %d", changeEndian(mem_read_data), number_of_words);
                  number_of_words <= number_of_words + 1;
                  read_addr <= read_addr + 1;  //update the memory address
              end else begin
              	state <= COMPUTE;
              end
          end
          COMPUTE:
          begin
          	if(count<80) begin

          		if(number_of_words < 80)begin
          			w[number_of_words%16] <= rotateW(w,count);
          			number_of_words <= number_of_words + 1;
          		end

                  //$display("count value : %d", count);
                  hash_code <= hash_op(h[0],h[1],h[2],h[3],h[4],w[count%16],count);             

                  count <= count + 1;

              end else begin

              	number_of_blocks <= number_of_blocks - 1;
              	hash_code_out[4] <= hash_code_out[4] + h[4];
              	hash_code_out[3] <= hash_code_out[3] + h[3];
              	hash_code_out[2] <= hash_code_out[2] + h[2];
              	hash_code_out[1] <= hash_code_out[1] + h[1];
              	hash_code_out[0] <= hash_code_out[0] + h[0];


              	//$display("number_of_blocks = %d, number_of_last_bytes = %d", number_of_blocks, number_of_last_bytes);
              	if(number_of_blocks == 3 && number_of_last_bytes > 55)begin

              		pad_one <= 1;

              		state <= IDLE;
              	end
                  //Then the next block is the last block
                  else if(number_of_blocks == 2 && number_of_last_bytes < 56) begin

                  	pad_one <= 1;

                  	state <= IDLE;
                  end

                  else if(number_of_blocks == 1) begin //already at the last block, start to write in next state
                  	state <= WRITE;
                  	count <= 0;
                  end else begin
                  	state <= IDLE;
                  end

                  block_complete <= 1;
                  read_addr = read_addr - 1;
              end
          end


          WRITE:
          begin
          		if(count == 0) begin
          			$display("hash_code out in write state: %x%x%x%x%x", 
          				hash_code_out[0],hash_code_out[1],hash_code_out[2],
          				hash_code_out[3],hash_code_out[4]);
          			state <= WRITE;
                   	mem_we <= 1; //start to write
                   	count <= count + 1;
                   	mem_write_data <= hash_code_out[0];
           		end else if (count < 5) begin //write to memory
                	mem_write_data <= hash_code_out[count];
                	write_addr <= write_addr + 1;
                	count <= count + 1;
                	state <= WRITE;
            	end else begin
                	state <= IDLE;
                	done <= 1;
            	end
            end
        endcase 
    end
end


function void pad_zero_and_message_size(input logic [31:0] message_size, input logic [7:0] idx);
	logic [7:0] i;

	if (number_of_blocks > 1) begin
          //$display("pad zero for the second last block");
          for (i = 0; i < 16; i++) begin
          	if (i >= idx)
          		w[i] = 32'b0;
          end
        end else if (number_of_blocks == 1) begin  //if last block
          //$display("idx should be 0 but is %d", idx);
          for (i = 0; i < 14; i++) begin
          	if (i >= idx)
          		w[i] = 32'b0;
          end 
          w[14] = 32'h00000000;
          w[15] = message_size;
      end 

      number_of_words = 15;

  endfunction

  function logic [31:0] changeEndian(input logic [31:0] value);
  	changeEndian = {value[7:0], value[15:8], value[23:16], value[31:24]};
  endfunction


  function logic [31:0] leftRotate (input logic [31:0] toRotate);
  	leftRotate = {toRotate[30:0],toRotate[31]};
  endfunction

  function logic [31:0] rotateW(input logic [31:0] w[16], input logic [7:0] count);
  	rotateW = leftRotate( w[((count)%16)] ^ w[(((count)%16)+2)%16] ^ w[(((count)%16)+8)%16] ^ w[(((count)%16)+13)%16]);
  endfunction

  function logic [15:0] determine_num_blocks(input logic [31:0] size);

  	logic [31:0] number_of_bits; 

  	number_of_bits = size << 3;

  	number_of_bits = number_of_bits + 64;

  	number_of_bits = number_of_bits/512;

  	determine_num_blocks = number_of_bits[15:0] + 1;
  endfunction

  function logic [159:0] hash_op(input logic [31:0] a, b, c, d, e, w,
  	input logic [7:0] t);

  logic [31:0] a1;
       //logic [15:0] b1;
       logic [31:0] c1;
       logic [31:0] temp;
       logic [31:0] k;

       logic [31:0] f;
       logic [159:0] hash_value;
       if(t >= 0 && t <= 19) begin
       	f = (b & c)|((~b) & d); 
       	k = 32'h5A827999;  
       end 
       else if(t >19 && t <= 39) begin
       	f = b ^ c ^ d; 
       	k = 32'h6ED9EBA1;   
       end
       else if(t >39 && t <= 59) begin
       	f = (b & c)|(b & d) | (c & d );
       	k = 32'h8F1BBCDC;

       end
       else if(t >59 && t <= 79) begin
       	f = b ^ c ^ d;   
       	k = 32'hCA62C1D6;
       end

       temp = {a[26:0],a[31:27]};
       a1 = temp + f + e + k + w;
       c1={b[1:0],b[31:2]};

       hash_op = {a1, a, c1, c, d};

   endfunction

endmodule

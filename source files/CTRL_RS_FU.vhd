----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:20:29 04/13/2021 
-- Design Name: 
-- Module Name:    CTRL_RS_FU - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CTRL_RS_FU is
    Port ( CLK : in STD_LOGIC;
			  RST	: in STD_LOGIC;
			  --FU1 to control
           Busy_RS_FU1 : in  STD_LOGIC_VECTOR(2 downto 0); --arithmetic FU
           Ready_RS_FU1 : in  STD_LOGIC_VECTOR(2 downto 0); --arithmetic FU
           RS_Arith_Avail : in  STD_LOGIC_VECTOR(2 downto 0); --arithmetic FU --mipws na mpainei apeutheias sto Issue unit?
			  FU1_result_ready : in STD_LOGIC;
			  FU1_busy : in STD_LOGIC;
			  --FU2 to control
           Busy_RS_FU2 : in  STD_LOGIC_VECTOR(1 downto 0); --logical FU
           Ready_RS_FU2 : in  STD_LOGIC_VECTOR(1 downto 0); --logical FU
           RS_Logic_Avail : in  STD_LOGIC_VECTOR(1 downto 0); --logical FU --mipws na mpainei apeutheias sto Issue unit?
			  FU2_result_ready : in STD_LOGIC;
  			  FU2_busy : in STD_LOGIC;
			  --CDB to control
			  FU1_Grant : in STD_LOGIC;			  
			  FU2_Grant : in STD_LOGIC;
			  FU3_Grant : in STD_LOGIC; --for 3rd FU --does not exist in this project
			  --Issue Unit to control
			  Issue_Logic : in STD_LOGIC; 
			  Issue_Arith : in STD_LOGIC; 
			  --control to FU1
           mux_rs_ctrl1 : out  STD_LOGIC_VECTOR(1 downto 0);
			  issue_at_fu1 : out STD_LOGIC_VECTOR(2 downto 0);
			  accepted_by_fu1 : out STD_LOGIC_VECTOR(2 downto 0);
			  wren_fu1 : out STD_LOGIC;
			  fu1_start : out STD_LOGIC;
			  --control to FU2
			  issue_at_fu2 : out STD_LOGIC_VECTOR(1 downto 0);
			  accepted_by_fu2 : out STD_LOGIC_VECTOR(1 downto 0);
			  wren_fu2 : out STD_LOGIC;
			  fu2_start : out STD_LOGIC;
			  mux_rs_ctrl2 : out  STD_LOGIC_VECTOR(1 downto 0);
			  --control to CDB
			  FU1_Req : out STD_LOGIC;			  
			  FU2_Req : out STD_LOGIC;
			  FU3_Req : out STD_LOGIC --for 3rd FU --does not exist in this project
			  );
end CTRL_RS_FU;

architecture Behavioral of CTRL_RS_FU is
--we will use 3 reg. one for each request.
component Regis_1bit is
    Port ( CLK : in STD_LOGIC;
           WriteEnable : in STD_LOGIC;
           RST : in STD_LOGIC;
           Datain : in STD_LOGIC;
           Dataout : out STD_LOGIC);
end component;

signal  t_mux_rs_ctrl1,t_mux_rs_ctrl2 : std_logic_vector(1 downto 0);
signal  t_issue_at_fu1,t_accepted_by_fu1 : std_logic_vector(2 downto 0);
signal  t_issue_at_fu2,t_accepted_by_fu2 : std_logic_vector(1 downto 0);
signal  t_wren_fu1,t_fu1_start,t_wren_fu2,t_fu2_start,t_FU1_Req,t_FU2_Req,t_FU3_Req,t_wren_fu3 : std_logic;

signal req_we1,req_we2,req_we3 : std_logic;
signal t_req_in1,t_req_out1,t_req_in2,t_req_out2,t_req_in3,t_req_out3 : std_logic;

begin

request1:
	Regis_1bit port map(CLK=>CLK,RST=>RST,WriteEnable=>req_we1,Datain=>t_req_in1,Dataout=>t_req_out1);

request2:
	Regis_1bit port map(CLK=>CLK,RST=>RST,WriteEnable=>req_we2,Datain=>t_req_in2,Dataout=>t_req_out2);

request3:
	Regis_1bit port map(CLK=>CLK,RST=>RST,WriteEnable=>req_we3,Datain=>t_req_in3,Dataout=>t_req_out3);

process
begin
	wait until CLK'EVENT AND CLK='0';
	if RST='1' then
		--control to FU1 - arith
		t_mux_rs_ctrl1<="11";
		t_issue_at_fu1<="000";
		t_accepted_by_fu1<="000";
		t_wren_fu1<='0';
		t_fu1_start<='0';
		--control to FU2 - logic
		t_issue_at_fu2<="00";
		t_accepted_by_fu2<="00";
		t_wren_fu2<='0';
		t_fu2_start<='0';
		t_mux_rs_ctrl2<="11";
		--control to CDB
		t_FU1_Req<='0';	  
		t_FU2_Req<='0';
		t_FU3_Req<='0';
		req_we1<='0';
		req_we2<='0';
		req_we3<='0';
		t_req_in1<='0';
		t_req_in2<='0';
		t_req_in3<='0';
	else
		--when there is an instr to issue
		if Issue_Arith='1' then
			if (RS_Arith_Avail="001" or RS_Arith_Avail="011" or RS_Arith_Avail="101" or RS_Arith_Avail="111") then
				t_issue_at_fu1<="001"; --FU_Arith - RS1 --if more than one RS is available I use RS1
				t_issue_at_fu2<="00";		
			elsif (RS_Arith_Avail="010" or RS_Arith_Avail="110") then
				t_issue_at_fu1<="010";--FU_Arith - RS2 --if more than one RS is available and RS1 is not avail. I use RS2
				t_issue_at_fu2<="00";
			else
				t_issue_at_fu1<="100";--FU_Arith - RS3
				t_issue_at_fu2<="00";
			end if;

		elsif Issue_Logic='1' then
			if(RS_Logic_Avail="01" or RS_Logic_Avail="11") then
				t_issue_at_fu2<="01";--FU_logic - RS1 --if both RS are available I use RS1
				t_issue_at_fu1<="000";
			else
				t_issue_at_fu2<="10"; --FU_logic - RS2
				t_issue_at_fu1<="000";
			end if;

		else
			t_issue_at_fu1<="000";
			t_issue_at_fu2<="00";
		end if;
		
	--FU1 accepts/doesn't accept		
		if (Ready_RS_FU1="001" or Ready_RS_FU1="011" or Ready_RS_FU1="101" or Ready_RS_FU1="111") then
			t_mux_rs_ctrl1<="00";
			t_accepted_by_fu1<="001"; --RS1 values accepted
			t_fu1_start<='1';
		elsif (Ready_RS_FU1="010" or Ready_RS_FU1="110") then
			t_mux_rs_ctrl1<="01";
			t_accepted_by_fu1<="010"; --RS2 values accepted
			t_fu1_start<='1';
		elsif (Ready_RS_FU1="100") then
			t_mux_rs_ctrl1<="10";
			t_accepted_by_fu1<="100"; --RS3 values accepted
			t_fu1_start<='1';
		else
			t_mux_rs_ctrl1<="11";
			t_accepted_by_fu1<="000";
			t_fu1_start<='0';
		end if;
	--FU2 accepts/doesn't accept
		if (Ready_RS_FU2="01" or Ready_RS_FU2="11") then
			t_mux_rs_ctrl2<="00";
			t_accepted_by_fu2<="01"; --RS1 values accepted
			t_fu2_start<='1';
		elsif (Ready_RS_FU2="10") then
			t_mux_rs_ctrl2<="01";
			t_accepted_by_fu2<="10"; --RS2 values accepted
			t_fu2_start<='1';
		else
			t_mux_rs_ctrl2<="11";
			t_accepted_by_fu2<="00"; 
			t_fu2_start<='0';
		end if;

		--for CDB -> Requests and Grants			
		--FU1 request and FU2 request
		if (FU1_result_ready='1' or (FU2_Grant='1' and t_req_out1='1' and t_req_out2='1')) then
			t_FU1_Req<='1';	
			req_we1<='1';
			t_req_in1<='1';
		else 
			t_FU1_Req<='0';
			req_we1<='0';
			t_req_in1<='0';
		end if;
		
		if (FU2_result_ready='1' or (FU1_Grant='1' and t_req_out1='1' and t_req_out2='1')) then
			t_FU2_Req<='1';
			req_we2<='1';
			t_req_in2<='1';
		else
			t_FU2_Req<='0';
			req_we2<='0';
			t_req_in2<='0';
		end if;
		
		--FU3 request
--		if FU3_result_ready='1' then
--			t_FU3_Req<='1';
--			req_we3<='1';
--			t_req_in3<='1';
--		else
			t_FU3_Req<='0';
			req_we3<='0';
			t_req_in3<='0';
--		end if;

			--FU1 grant
			if FU1_Grant='1' and t_req_out1='1' and FU1_result_ready='0' then
				req_we1<='1';
				t_req_in1<='0';
				t_wren_fu1<='1'; --wren will be inactive only when not granted from cdb
			elsif  FU1_Grant='0' and t_req_out1='1' and FU1_result_ready='0' then
				req_we1<='0';
				t_req_in1<='0';
				t_wren_fu1<='0'; --wren will be inactive only when not granted from cdb 
			else
				t_wren_fu1<='1'; --wren will be inactive only when not granted from cdb
			end if;

			--FU2 grant
			if FU2_Grant='1' and t_req_out2='1' and FU2_result_ready='0' then
				req_we2<='1';
				t_req_in2<='0';
				t_wren_fu2<='1'; --wren will be inactive only when not granted from cdb 
			elsif  FU2_Grant='0' and t_req_out2='1' and FU2_result_ready='0' then
				req_we2<='0';
				t_req_in2<='0';
				t_wren_fu2<='0'; --wren will be inactive only when not granted from cdb
			else
				t_wren_fu2<='1'; --wren will be inactive only when not granted from cdb
			end if;		

		--FU3 grant
		if FU3_Grant='1' and t_req_out3='1' then
			req_we3<='1';
			t_req_in3<='0';
			t_wren_fu3<='1'; --wren will be inactive only when not granted from cdb
		elsif  FU3_Grant='0' and t_req_out3='1' then
			req_we3<='0';
			t_req_in3<='0';
			t_wren_fu3<='0'; --wren will be inactive only when not granted from cdb
		else
			req_we3<='0';
			t_req_in3<='0';
			t_wren_fu3<='1'; --wren will be inactive only when not granted from cdb
		end if;		
		

	end if;
end process;

--outputs
--control to FU1
mux_rs_ctrl1<=t_mux_rs_ctrl1;
issue_at_fu1<=t_issue_at_fu1;
accepted_by_fu1<=t_accepted_by_fu1;
wren_fu1<=t_wren_fu1;
fu1_start<=t_fu1_start;
--control to FU2
issue_at_fu2<=t_issue_at_fu2;
accepted_by_fu2<=t_accepted_by_fu2;
wren_fu2<=t_wren_fu2;
fu2_start<=t_fu2_start;
mux_rs_ctrl2<=t_mux_rs_ctrl2;
--control to CDB
FU1_Req<=t_FU1_Req;	  
FU2_Req<=t_FU2_Req;
FU3_Req<=t_FU3_Req;

end Behavioral;


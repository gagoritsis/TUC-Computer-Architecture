----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:24:20 04/24/2021 
-- Design Name: 
-- Module Name:    FU_2 - Behavioral 
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

--Logic Functional Unit
entity FU_2 is
    Port ( CLK : in STD_LOGIC;
			  RST	: in STD_LOGIC;
			  WriteEnable: in STD_LOGIC;
			  Op : in  STD_LOGIC_VECTOR (1 downto 0);
			  CDB_Q : in  STD_LOGIC_VECTOR (4 downto 0);
			  CDB_V : in  STD_LOGIC_VECTOR (31 downto 0);
           Vj : in  STD_LOGIC_VECTOR (31 downto 0);
           Vk : in  STD_LOGIC_VECTOR (31 downto 0);
			  Qj : in  STD_LOGIC_VECTOR (4 downto 0);
			  Qk : in  STD_LOGIC_VECTOR (4 downto 0);
			  mux_rs_control : in  STD_LOGIC_VECTOR (1 downto 0); --common control for Vj, Vk and Op
			  Issue : in  STD_LOGIC_VECTOR (1 downto 0); 
			  Accepted : in  STD_LOGIC_VECTOR (1 downto 0); 
			  FU_start : in STD_LOGIC;
			  RS_tag : in STD_LOGIC_VECTOR (4 downto 0);
			  Busy : out STD_LOGIC_VECTOR (1 downto 0);
			  Avail_to_Issue : out STD_LOGIC_VECTOR (1 downto 0);
			  Ready : out STD_LOGIC_VECTOR (1 downto 0);
			  Available : out STD_LOGIC_VECTOR (1 downto 0);
			  CDB_Qout : out STD_LOGIC_VECTOR (4 downto 0);
			  CDB_Vout : out STD_LOGIC_VECTOR (31 downto 0);
           LU_busy : out STD_LOGIC;
			  LU_result_ready : out  STD_LOGIC);
end FU_2;

architecture Behavioral of FU_2 is
component RS is
    Port ( CLK : in STD_LOGIC;
			  RST : in STD_LOGIC;
			  ISSUE : in STD_LOGIC; 
			  Accepted : in STD_LOGIC;
			  Op : in  STD_LOGIC_VECTOR (1 downto 0);
			  CDB_Q : in STD_LOGIC_VECTOR (4 downto 0);
			  CDB_V : in STD_LOGIC_VECTOR (31 downto 0);
           Vj : in  STD_LOGIC_VECTOR (31 downto 0);
           Vk : in  STD_LOGIC_VECTOR (31 downto 0);
			  Qj : in  STD_LOGIC_VECTOR (4 downto 0);
           Qk : in  STD_LOGIC_VECTOR (4 downto 0);
			  RS_tag : in STD_LOGIC_VECTOR (4 downto 0);
			  Opout : out STD_LOGIC_VECTOR (1 downto 0);
			  Busy : out STD_LOGIC;
			  Avail_to_Issue : out STD_LOGIC;			  
			  Ready : out STD_LOGIC;
			  Available : out STD_LOGIC;
			  Vjout : out STD_LOGIC_VECTOR (31 downto 0);
           Vkout : out STD_LOGIC_VECTOR (31 downto 0));
end component;

component MUX4_1 is
    Port ( sel : in  STD_LOGIC_VECTOR(1 downto 0);
			  datain0 : in  STD_LOGIC_VECTOR (31 downto 0);
           datain1 : in  STD_LOGIC_VECTOR (31 downto 0);
			  datain2 : in  STD_LOGIC_VECTOR (31 downto 0);
           datain3 : in  STD_LOGIC_VECTOR (31 downto 0);
           dataout : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

component MUX4_1_2bits is
    Port ( sel : in  STD_LOGIC_VECTOR(1 downto 0);
			  datain0 : in  STD_LOGIC_VECTOR (1 downto 0);
           datain1 : in  STD_LOGIC_VECTOR (1 downto 0);
			  datain2 : in  STD_LOGIC_VECTOR (1 downto 0);
           datain3 : in  STD_LOGIC_VECTOR (1 downto 0);
           dataout : out  STD_LOGIC_VECTOR (1 downto 0));
end component;


component Regis is
	Port ( CLK : in STD_LOGIC;
           WriteEnable : in STD_LOGIC;
           RST : in STD_LOGIC;
           Datain : in STD_LOGIC_VECTOR (31 downto 0);
           Dataout : out STD_LOGIC_VECTOR (31 downto 0));
end component;

component Regis_1bit is
    Port ( CLK : in STD_LOGIC;
           WriteEnable : in STD_LOGIC;
           RST : in STD_LOGIC;
           Datain : in STD_LOGIC;
           Dataout : out STD_LOGIC);
end component;

component Regis_5bits is
    Port ( CLK : in STD_LOGIC;
           WriteEnable : in STD_LOGIC;
           RST : in STD_LOGIC;
           Datain : in STD_LOGIC_VECTOR (4 downto 0);
           Dataout : out STD_LOGIC_VECTOR (4 downto 0));
end component;

signal tempout_mux1 : std_logic_vector(31 downto 0);
signal tempout_mux2 : std_logic_vector(31 downto 0);
signal tempout_mux3 : std_logic_vector (1 downto 0); --Opcode

signal tempout_logic_result : std_logic_vector(31 downto 0);
signal tempout_reg1 : std_logic_vector(31 downto 0);
signal tempout_reg2 : std_logic_vector(31 downto 0);
signal temp_tag,tempout_reg3,tempout_reg4 : std_logic_vector(4 downto 0);

signal tempGrant : std_logic_vector(2 downto 0);

--RS signals
signal ready1,ready2,busy1,busy2,avail1,avail2,avail_to_issue1,avail_to_issue2 : std_logic;
signal out_vj1,out_vj2,out_vk1,out_vk2 : std_logic_vector(31 downto 0);
signal opout1,opout2 : std_logic_vector(1 downto 0);

--FU signals
signal LU_ready1,LU_ready2,temp_LU_busy : std_logic;

begin
--connections
mux1: --vj
	MUX4_1 port map(sel=>mux_rs_control, datain0=>out_vj1(31 downto 0), datain1=>out_vj2(31 downto 0), 
					datain2=>x"00000000",datain3=>x"00000000", dataout=>tempout_mux1);
mux2: --vk
	MUX4_1 port map(sel=>mux_rs_control, datain0=>out_vk1(31 downto 0), datain1=>out_vk2(31 downto 0), 
					datain2=>x"00000000",datain3=>x"00000000", dataout=>tempout_mux2);
mux3: --op
	MUX4_1_2bits port map(sel=>mux_rs_control, datain0=>opout1(1 downto 0), datain1=>opout2(1 downto 0), 
					datain2=>"00",datain3=>"00", dataout=>tempout_mux3);
regis1: --CDB_V
	Regis port map(CLK=>CLK, WriteEnable=>WriteEnable, RST=>RST, Datain=>tempout_logic_result, Dataout=>tempout_reg1);
 
regis2:	--CDB_V
	Regis port map(CLK=>CLK, WriteEnable=>WriteEnable, RST=>RST, Datain=>tempout_reg1, Dataout=>tempout_reg2);

regis4: --CDB_Q
	Regis_5bits port map(CLK=>CLK, WriteEnable=>WriteEnable, RST=>RST, Datain=>temp_tag, Dataout=>tempout_reg3);

regis5: --CDB_Q
	Regis_5bits port map(CLK=>CLK, WriteEnable=>WriteEnable, RST=>RST, Datain=>tempout_reg3, Dataout=>tempout_reg4);

RS1:
	RS port map(CLK =>CLK, RST=>RST,ISSUE=>Issue(0), Accepted=>Accepted(0) ,Op=>Op ,CDB_Q=>CDB_Q, CDB_V=>CDB_V, Qj=>Qj, Qk=>Qk,
 			Vj=>Vj, Vk=>Vk, Opout=>opout1, Vjout=>out_vj1, Vkout=>out_vk1, Avail_to_Issue=>avail_to_issue1,
				Ready=>ready1, Busy=>busy1, Available=>avail1,RS_tag=>RS_tag);

RS2:
	RS port map(CLK =>CLK, RST=>RST,ISSUE=>Issue(1), Accepted=>Accepted(1) ,Op=>Op ,CDB_Q=>CDB_Q, CDB_V=>CDB_V, Qj=>Qj, Qk=>Qk,
 			Vj=>Vj, Vk=>Vk, Opout=>opout2, Vjout=>out_vj2, Vkout=>out_vk2, Avail_to_Issue=>avail_to_issue2,
				Ready=>ready2, Busy=>busy2, Available=>avail2,RS_tag=>RS_tag);

Ready_for_grant_reg1:
	Regis_1bit port map(CLK=>CLK, WriteEnable=>WriteEnable, RST=>RST, Datain=>LU_ready1, Dataout=>LU_ready2);


process(CLK,RST,WriteEnable,FU_start,tempout_mux3,tempout_mux1,tempout_mux2,mux_rs_control)
begin
	if RST='1' then
		tempout_logic_result<=x"00000000";
		temp_LU_busy<='0';
		LU_ready1<='0';
	else
		if FU_start='1' then
			--tempout_mux3 is the result from mux3, which is the Opcode from a specific RS
			if(tempout_mux3(1 downto 0)="00") then
				tempout_logic_result <= tempout_mux1 or tempout_mux2; --Vj or Vk
				LU_ready1<='1';
			elsif (tempout_mux3(1 downto 0)="01") then
				tempout_logic_result <= tempout_mux1 and tempout_mux2; --Vj and Vk
				LU_ready1<='1';
			elsif (tempout_mux3(1 downto 0)="10") then
				tempout_logic_result <= not tempout_mux1; --not Vj
				LU_ready1<='1';
			else
				tempout_logic_result <= tempout_logic_result; --do nothing
				LU_ready1<='0';
			end if;
			
			if (mux_rs_control="00") then
				temp_tag<="10001"; --FU2 RS1
			elsif (mux_rs_control="01") then
				temp_tag<="10010"; --FU2 RS2
			else
				temp_tag<="00000"; --invalid tag
			end if;
			
			temp_LU_busy<='1';
			
		else
			tempout_logic_result <= tempout_logic_result; --do nothing
			LU_ready1<='0';
			temp_LU_busy<='0';
			temp_tag<="00000"; --invalid tag
		end if;
	end if;
end process;

--outputs to CTRL_RS_FU
Busy<=(busy2 & busy1);
Ready<=(ready2 & ready1);
Available<=(avail2 & avail1);
LU_busy<=temp_LU_busy;
LU_result_ready<=LU_ready2;

--outputs to ISSUE
Avail_to_Issue<=(avail_to_issue2 & avail_to_issue1);

--outputs to CDB
CDB_Vout<=tempout_reg2;
CDB_Qout<=tempout_reg4;

end Behavioral;

----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:12:04 04/04/2021 
-- Design Name: 
-- Module Name:    FU_1 - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

--Arithmetic Functional Unit
entity FU_1 is
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
			  Issue : in  STD_LOGIC_VECTOR (2 downto 0); 
			  Accepted : in  STD_LOGIC_VECTOR (2 downto 0); 
			  FU_start : in STD_LOGIC;
			  RS_tag : in  STD_LOGIC_VECTOR (4 downto 0);
			  Busy : out STD_LOGIC_VECTOR (2 downto 0);
			  Avail_to_Issue : out STD_LOGIC_VECTOR (2 downto 0);
			  Ready : out STD_LOGIC_VECTOR (2 downto 0);
			  Available : out STD_LOGIC_VECTOR (2 downto 0);
			  CDB_Qout : out STD_LOGIC_VECTOR (4 downto 0);
			  CDB_Vout : out STD_LOGIC_VECTOR (31 downto 0);
           AU_busy : out STD_LOGIC;
			  AU_result_ready : out  STD_LOGIC);
end FU_1;

architecture Behavioral of FU_1 is
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
			  RS_tag : in  STD_LOGIC_VECTOR (4 downto 0);
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

signal tempout_arith_result : std_logic_vector(31 downto 0);
signal tempout_reg1 : std_logic_vector(31 downto 0);
signal tempout_reg2 : std_logic_vector(31 downto 0);
signal tempout_reg3 : std_logic_vector(31 downto 0);
signal temp_tag,tempout_reg4,tempout_reg5,tempout_reg6 : std_logic_vector(4 downto 0);

signal tempGrant : std_logic_vector(2 downto 0);

--RS signals
signal ready1,ready2,ready3,busy1,busy2,busy3,avail1,avail2,avail3,avail_to_issue1,avail_to_issue2,avail_to_issue3 : std_logic;
signal out_vj1,out_vj2,out_vj3,out_vk1,out_vk2,out_vk3 : std_logic_vector(31 downto 0);
signal opout1,opout2,opout3 : std_logic_vector(1 downto 0);

--FU signals
signal AU_ready1,AU_ready2,AU_ready3,temp_AU_busy : std_logic;

--for ssl x1 x2 x3
signal offset : integer;

begin
--connections
mux1: --vj
	MUX4_1 port map(sel=>mux_rs_control, datain0=>out_vj1(31 downto 0), datain1=>out_vj2(31 downto 0), 
					datain2=>out_vj3(31 downto 0),datain3=>x"00000000", dataout=>tempout_mux1);

mux2: --vk
	MUX4_1 port map(sel=>mux_rs_control, datain0=>out_vk1(31 downto 0), datain1=>out_vk2(31 downto 0), 
					datain2=>out_vk3(31 downto 0),datain3=>x"00000000", dataout=>tempout_mux2);
mux3: --op
	MUX4_1_2bits port map(sel=>mux_rs_control, datain0=>opout1(1 downto 0), datain1=>opout2(1 downto 0), 
					datain2=>opout3(1 downto 0),datain3=>"00", dataout=>tempout_mux3);
regis1: --CDB_V
	Regis port map(CLK=>CLK, WriteEnable=>WriteEnable, RST=>RST, Datain=>tempout_arith_result, Dataout=>tempout_reg1);
 
regis2:	--CDB_V
	Regis port map(CLK=>CLK, WriteEnable=>WriteEnable, RST=>RST, Datain=>tempout_reg1, Dataout=>tempout_reg2);

regis3:	--CDB_V
	Regis port map(CLK=>CLK, WriteEnable=>WriteEnable, RST=>RST, Datain=>tempout_reg2, Dataout=>tempout_reg3);

regis4: --CDB_Q
	Regis_5bits port map(CLK=>CLK, WriteEnable=>WriteEnable, RST=>RST, Datain=>temp_tag, Dataout=>tempout_reg4);

regis5: --CDB_Q
	Regis_5bits port map(CLK=>CLK, WriteEnable=>WriteEnable, RST=>RST, Datain=>tempout_reg4, Dataout=>tempout_reg5);

regis6: --CDB_Q 
	Regis_5bits port map(CLK=>CLK, WriteEnable=>WriteEnable, RST=>RST, Datain=>tempout_reg5, Dataout=>tempout_reg6);

RS1:
	RS port map(CLK =>CLK, RST=>RST,ISSUE=>Issue(0), Accepted=>Accepted(0) ,Op=>Op ,CDB_Q=>CDB_Q, CDB_V=>CDB_V, Qj=>Qj, Qk=>Qk,
 			Vj=>Vj, Vk=>Vk, Opout=>opout1, Vjout=>out_vj1, Vkout=>out_vk1, Avail_to_Issue=>avail_to_issue1,
				Ready=>ready1, Busy=>busy1, Available=>avail1,RS_tag=>RS_tag);

RS2:
	RS port map(CLK =>CLK, RST=>RST,ISSUE=>Issue(1), Accepted=>Accepted(1) ,Op=>Op ,CDB_Q=>CDB_Q, CDB_V=>CDB_V, Qj=>Qj, Qk=>Qk,
 			Vj=>Vj, Vk=>Vk, Opout=>opout2, Vjout=>out_vj2, Vkout=>out_vk2, Avail_to_Issue=>avail_to_issue2,
				Ready=>ready2, Busy=>busy2, Available=>avail2,RS_tag=>RS_tag);

RS3:
	RS port map(CLK =>CLK, RST=>RST,ISSUE=>Issue(2), Accepted=>Accepted(2) ,Op=>Op ,CDB_Q=>CDB_Q, CDB_V=>CDB_V, Qj=>Qj, Qk=>Qk,
 			Vj=>Vj, Vk=>Vk, Opout=>opout3, Vjout=>out_vj3, Vkout=>out_vk3, Avail_to_Issue=>avail_to_issue3,
				Ready=>ready3, Busy=>busy3, Available=>avail3,RS_tag=>RS_tag);

Ready_for_grant_reg1:
	Regis_1bit port map(CLK=>CLK, WriteEnable=>WriteEnable, RST=>RST, Datain=>AU_ready1, Dataout=>AU_ready2);

Ready_for_grant_reg2:
	Regis_1bit port map(CLK=>CLK, WriteEnable=>WriteEnable, RST=>RST, Datain=>AU_ready2, Dataout=>AU_ready3);


--for ssl
offset<=to_integer(unsigned(tempout_mux2)); --tempout_mux2 is Vk

process(CLK,RST,WriteEnable,FU_start,tempout_mux3,tempout_mux1,tempout_mux2,mux_rs_control,offset)
begin
	--wait until CLK'EVENT AND CLK='0';
	if RST='1' then
		tempout_arith_result<=x"00000000";
		temp_AU_busy<='0';
		AU_ready1<='0';
	else
		if FU_start='1' then
			--tempout_mux3 is the result from mux3, which is the Opcode from a specific RS
			if(tempout_mux3(1 downto 0)="00") then
				tempout_arith_result <= tempout_mux1 + tempout_mux2; --add
				AU_ready1<='1';
			elsif (tempout_mux3(1 downto 0)="01") then
				tempout_arith_result <= tempout_mux1 - tempout_mux2; --sub
				AU_ready1<='1';
			elsif (tempout_mux3(1 downto 0)="10") then
				tempout_arith_result <= std_logic_vector(shift_left(unsigned(tempout_mux1),offset)); --ssl x1 x2 x3
				AU_ready1<='1'; 
			else
				tempout_arith_result <= tempout_arith_result; --do nothing
				AU_ready1<='0';
			end if;
			
			if (mux_rs_control="00") then 
				temp_tag<="01001"; --FU1 RS1
			elsif (mux_rs_control="01") then
				temp_tag<="01010"; --FU1 RS2
			elsif (mux_rs_control="10") then 
				temp_tag<="01011"; --FU1 RS3
			else
				temp_tag<="00000"; --invalid tag
			end if;
			
			temp_AU_busy<='1';
		
		else
			tempout_arith_result <= tempout_arith_result; --do nothing
			AU_ready1<='0';
			temp_AU_busy<='0';
			temp_tag<="00000"; --invalid tag
		end if;
	end if;
end process;

--outputs to CTRL_RS_FU
Busy<=(busy3 & busy2 & busy1);
Ready<=(ready3 & ready2 & ready1);
Available<=(avail3 & avail2 & avail1);
AU_busy<=temp_AU_busy;
AU_result_ready<=AU_ready3;

--outputs to ISSUE
Avail_to_Issue<=(avail_to_issue3 & avail_to_issue2 & avail_to_issue1);

--outputs to CDB
CDB_Vout<=tempout_reg3;
CDB_Qout<=tempout_reg6;
--Grant<= 

end Behavioral;


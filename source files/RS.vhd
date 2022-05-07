----------------------------------------------------------------------------------
-- Company: Technical University of Crete	
-- Engineer: Georgios Agoritsis
-- 
-- Create Date:    15:14:55 04/04/2021 
-- Design Name: 
-- Module Name:    RS - Behavioral 
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

entity RS is
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
end RS;

architecture Behavioral of RS is
component MUX2_1 is
	 Port ( sel : in  STD_LOGIC;
			  datain0 : in  STD_LOGIC_VECTOR (31 downto 0);
           datain1 : in  STD_LOGIC_VECTOR (31 downto 0);
           dataout : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

component MUX2_1_5bits is
	 Port ( sel : in  STD_LOGIC;
			  datain0 : in  STD_LOGIC_VECTOR (4 downto 0);
           datain1 : in  STD_LOGIC_VECTOR (4 downto 0);
           dataout : out  STD_LOGIC_VECTOR (4 downto 0));
end component;

component Regis is
	Port ( CLK : in STD_LOGIC;
           WriteEnable : in STD_LOGIC;
           RST : in STD_LOGIC;
           Datain : in STD_LOGIC_VECTOR (31 downto 0);
           Dataout : out STD_LOGIC_VECTOR (31 downto 0));
end component;

component Regis_5bits is
    Port ( CLK : in STD_LOGIC;
           WriteEnable : in STD_LOGIC;
           RST : in STD_LOGIC;
           Datain : in STD_LOGIC_VECTOR (4 downto 0);
           Dataout : out STD_LOGIC_VECTOR (4 downto 0));
end component;

component Regis_2bits is
    Port ( CLK : in STD_LOGIC;
           WriteEnable : in STD_LOGIC;
           RST : in STD_LOGIC;
           Datain : in STD_LOGIC_VECTOR (1 downto 0);
           Dataout : out STD_LOGIC_VECTOR (1 downto 0));
end component;

component Regis_1bit is
    Port ( CLK : in STD_LOGIC;
           WriteEnable : in STD_LOGIC;
           RST : in STD_LOGIC;
           Datain : in STD_LOGIC;
           Dataout : out STD_LOGIC);
end component;

signal tempout_mux1,tempout_mux2 : std_logic_vector(31 downto 0);
signal tempout_mux3,tempout_mux4 : std_logic_vector(4 downto 0);
signal tempout_reg1,tempout_reg2 : std_logic_vector(31 downto 0);
signal tempout_reg3,tempout_reg4, tempout_reg9 : std_logic_vector(4 downto 0);
signal tempout_reg5 : std_logic_vector(1 downto 0);

signal temp_busy_out : std_logic;
signal RST_vj, EN_vj, RST_vk, EN_vk, RST_qj, EN_qj, RST_qk, EN_qk, RST_op, EN_op, RST_busy, EN_busy,RST_ready,EN_ready,RST_avail,EN_avail,EN_tag,RST_tag: std_logic;
signal vj_from_CDB, vk_from_CDB : std_logic; --for sel of mux 1 and 2
signal temp_ready,temp_avail : std_logic;

signal av : std_logic;

begin

process(RST,ISSUE,Accepted,Qj,Qk,CDB_Q,tempout_reg3,tempout_reg4,temp_ready,temp_avail,tempout_reg9)
begin 
		--busy and available signals
		if RST='1' or tempout_reg9=CDB_Q then
			RST_busy<='1';
			RST_avail<='0';
			EN_busy<='0';
			EN_avail<='1';
			av<='1';
		end if;
	
		--remaining signals and conditions
		if RST='1' then
			RST_vj<='1';
			RST_vk<='1';
			RST_qj<='1';
			RST_qk<='1';
			RST_op<='1';
			RST_ready<='1';
			RST_tag<='1';
			
			EN_vj<='0';
			EN_vk<='0';
			EN_qj<='0';
			EN_qk<='0';
			EN_op<='0';
			EN_ready<='0';
			EN_tag<='0';
			
			
			vj_from_CDB<='0';
			vk_from_CDB<='0';
			
		elsif (ISSUE='1' and temp_avail='1' and temp_ready='0') then
			RST_vj<='0';
			RST_vk<='0';
			RST_qj<='0';
			RST_qk<='0';
			RST_op<='0';
			RST_tag<='0';
			
			EN_vj<='1';
			EN_vk<='1';
			EN_qj<='1';
			EN_qk<='1';
			EN_op<='1';
			EN_tag<='1'; --initialize tag
			
			RST_busy<='0';
			RST_avail<='1';
			EN_busy<='1';
			EN_avail<='0';
			av<='0';

			
			vj_from_CDB<='0';
			vk_from_CDB<='0';
			
			--if V registers valid and ready then RS is ready for the FU
			if (Qj="00000" and Qk="00000") then --tempout_reg3/tempout_reg4 are Qjout/Qkout
				RST_ready<='0';
				EN_ready<='1';
			else
				RST_ready<='1';
				EN_ready<='0';				
			end if;
			
		--if CDB_Q matches with Qj and RS busy 
		elsif (CDB_Q=tempout_reg3 and CDB_Q/="00000" and temp_busy_out='1' and temp_avail='0' and ISSUE='0') then 
			RST_vj<='0';
			RST_vk<='0';
			RST_qj<='1'; --set Qj tag to zero
			RST_qk<='0';
			RST_op<='0';
			RST_tag<='0';
			
			EN_vj<='1'; --write at Vj
			EN_vk<='0';
			EN_qj<='0';
			EN_qk<='0';
			EN_op<='0';
			EN_tag<='0';
			
			if tempout_reg4="00000" then
				EN_ready<='1'; --set ready 1
				RST_ready<='0';
			else
				EN_ready<='0'; 
				RST_ready<='1';--set ready 0
			end if;
			
			vj_from_CDB<='1'; --from CDB
			vk_from_CDB<='0';
			
		--if CDB_Q matches with Qk and RS busy
		elsif (CDB_Q=tempout_reg4 and CDB_Q/="00000" and temp_busy_out='1' and temp_avail='0' and ISSUE='0') then
			RST_vj<='0';
			RST_vk<='0';
			RST_qj<='0';
			RST_qk<='1'; --set Qk tag to zero
			RST_op<='0';
			RST_tag<='0';
			
			EN_vj<='0';
			EN_vk<='1'; --write at Vk
			EN_qj<='0';
			EN_qk<='0';
			EN_op<='0';
			EN_tag<='0';
			
			if tempout_reg3="00000" then
				EN_ready<='1'; --set ready 1
				RST_ready<='0';
			else
				EN_ready<='0'; 
				RST_ready<='1';--set ready 0
			end if;
			
			vj_from_CDB<='0';
			vk_from_CDB<='1'; --from CDB		
		
		--CDB_Q matches both Qk and Qj
		elsif (CDB_Q=tempout_reg4 and CDB_Q=tempout_reg3 and CDB_Q/="00000" and temp_busy_out='1' and temp_avail='0' and ISSUE='0') then
			RST_vj<='0';
			RST_vk<='0';
			RST_qj<='1'; --set Qj tag to zero
			RST_qk<='1'; --set Qk tag to zero
			RST_op<='0';
			RST_tag<='0';
			RST_ready<='0';

			EN_vj<='1'; --write at Vj
			EN_vk<='1'; --write at Vk
			EN_qj<='0';
			EN_qk<='0';
			EN_op<='0';
			EN_tag<='0';
			EN_ready<='1'; --set ready 1
			
			av<='0';
				
		--if accepted from FU - empty RS
		elsif (Accepted='1' and temp_busy_out='1' and temp_avail='0' and ISSUE='0' and temp_ready='1') then
			RST_vj<='1';
			RST_vk<='1';
			RST_qj<='1'; 
			RST_qk<='1';
			RST_op<='1';
			RST_tag<='0';
			RST_ready<='1'; --set ready to 0
			
			EN_vj<='0'; 
			EN_vk<='0';
			EN_qj<='0';
			EN_qk<='0';
			EN_op<='0';
			EN_tag<='0';
			EN_ready<='0';
			
			vj_from_CDB<='0'; 
			vk_from_CDB<='0';
		
		else
			RST_vj<='0';
			RST_vk<='0';
			RST_qj<='0';
			RST_qk<='0';
			RST_op<='0';
			RST_tag<='0';
			RST_ready<='0'; 
			
			EN_vj<='0';
			EN_vk<='0';
			EN_qj<='0';
			EN_qk<='0';
			EN_op<='0';
			EN_tag<='0';
			EN_ready<='0';
			
			
			vj_from_CDB<='0';
			vk_from_CDB<='0';
			
		end if;
end process;

--outputs
Vjout<=tempout_reg1;
Vkout<=tempout_reg2;
Opout<=tempout_reg5;
Busy<=temp_busy_out;
Avail_to_Issue<=av;
Ready<=temp_ready;
Available<=temp_avail;

 
--port maps
mux1_regvj:
	MUX2_1 port map(sel=>vj_from_CDB, datain0=>Vj(31 downto 0), datain1=>CDB_V(31 downto 0), dataout=>tempout_mux1);

mux2_regvk:
	MUX2_1 port map(sel=>vk_from_CDB, datain0=>Vk(31 downto 0), datain1=>CDB_V(31 downto 0), dataout=>tempout_mux2);

regis1_vj:
	Regis port map(CLK=>CLK, WriteEnable=>EN_vj, RST=>RST_vj, Datain=>tempout_mux1(31 downto 0), Dataout=>tempout_reg1);

regis2_vk:	
	Regis port map(CLK=>CLK, WriteEnable=>EN_vk, RST=>RST_vk, Datain=>tempout_mux2(31 downto 0), Dataout=>tempout_reg2);

regis3_qj:
	Regis_5bits port map(CLK=>CLK, WriteEnable=>EN_qj, RST=>RST_qj, Datain=>Qj(4 downto 0), Dataout=>tempout_reg3);

regis4_qk:	
	Regis_5bits port map(CLK=>CLK, WriteEnable=>EN_qk, RST=>RST_qk, Datain=>Qk(4 downto 0), Dataout=>tempout_reg4);

regis5_op:
	Regis_2bits port map(CLK=>CLK, WriteEnable=>EN_op, RST=>RST_op, Datain=>Op(1 downto 0), Dataout=>tempout_reg5);

regis6_busy:
	Regis_1bit port map(CLK=>CLK, WriteEnable=>EN_busy, RST=>RST_busy, Datain=>'1', Dataout=>temp_busy_out);

regis7_ready:
	Regis_1bit port map(CLK=>CLK, WriteEnable=>EN_ready, RST=>RST_ready, Datain=>'1', Dataout=>temp_ready);

regis8_avail:
	Regis_1bit port map(CLK=>CLK, WriteEnable=>EN_avail, RST=>RST_avail, Datain=>'1', Dataout=>temp_avail);

regis9_tag:
	Regis_5bits port map(CLK=>CLK, WriteEnable=>EN_tag, RST=>RST_tag, Datain=>RS_tag(4 downto 0), Dataout=>tempout_reg9);

end Behavioral;

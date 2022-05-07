----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:39:04 04/10/2021 
-- Design Name: 
-- Module Name:    RF_Register - Behavioral 
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

entity RF_Register is
	   Port ( CLK : in STD_LOGIC;
				RST	: in STD_LOGIC;
				WrEn: in STD_LOGIC;
				Issue_RS_tag : in  STD_LOGIC_VECTOR (4 downto 0); -- to initialize Q from Issue Unit
				CDB_Q : in  STD_LOGIC_VECTOR (4 downto 0);
			   CDB_V : in  STD_LOGIC_VECTOR (31 downto 0);
				Qout : out  STD_LOGIC_VECTOR (4 downto 0);
			   Vout : out  STD_LOGIC_VECTOR (31 downto 0)

				);

end RF_Register;

architecture Behavioral of RF_Register is
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

signal temp_q_out : std_logic_vector(4 downto 0);
signal temp_v_out : std_logic_vector(31 downto 0);
signal temp_q_in	: std_logic_vector(4 downto 0);
signal temp_v_we	: std_logic;
signal temp_q_we	: std_logic;


begin

v_reg:
	Regis port map(CLK=>CLK, WriteEnable=>temp_v_we, RST=>RST, Datain=>CDB_V, Dataout=>temp_v_out);
	
q_reg:	
	Regis_5bits port map(CLK=>CLK, WriteEnable=>temp_q_we, RST=>RST, Datain=>temp_q_in, Dataout=>temp_q_out);

process(CLK,RST,WrEn,CDB_Q,Issue_RS_tag,temp_q_out)
begin
	--Issue Unit initialization
	if falling_edge(CLK) then
		if (WrEn='1') then
			temp_q_in<=Issue_RS_tag;
			temp_v_we<='0';
		else
			--Data from CDB control
			if(temp_q_out=CDB_Q and temp_q_out/="00000") then --if CDB_Q matches then write CDB_V in V register and make Q register (tag) "00000"
				temp_q_in<="00000"; 
				temp_v_we<='1';
			else
				temp_q_in<="00000"; --???
				temp_v_we<='0';
			end if;
		end if;
		--Q register WriteEnable signal
		if WrEn='1' then
			temp_q_we<=WrEn;
		else 
			temp_q_we<=temp_v_we; --or WrEn from Issue Unit or CDB_Q matches with temp_w_out and I have to set Q register to "00000"
		end if;
	end if;
end process;


Qout<=temp_q_out;
Vout<=temp_v_out;
end Behavioral;


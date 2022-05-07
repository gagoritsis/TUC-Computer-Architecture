----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:19:19 04/21/2021 
-- Design Name: 
-- Module Name:    CDB - Behavioral 
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

entity CDB is
    Port ( CLK : in STD_LOGIC;
			  RST : in STD_LOGIC;
			  FU1_Qin : in  STD_LOGIC_VECTOR (4 downto 0);
           FU1_Vin : in  STD_LOGIC_VECTOR (31 downto 0);
           FU2_Qin : in  STD_LOGIC_VECTOR (4 downto 0);
           FU2_Vin : in  STD_LOGIC_VECTOR (31 downto 0);
           FU3_Qin : in  STD_LOGIC_VECTOR (4 downto 0);
           FU3_Vin : in  STD_LOGIC_VECTOR (31 downto 0);
			  FU1_Req : in STD_LOGIC;
			  FU2_Req : in STD_LOGIC;
			  FU3_Req : in STD_LOGIC;
			  FU1_Grant : out STD_LOGIC;
			  FU2_Grant : out STD_LOGIC;
			  FU3_Grant : out STD_LOGIC;
           CDB_Q : out  STD_LOGIC_VECTOR (4 downto 0);
           CDB_V : out  STD_LOGIC_VECTOR (31 downto 0));
end CDB;

architecture Behavioral of CDB is
component MUX4_1 is
    Port ( sel : in  STD_LOGIC_VECTOR(1 downto 0);
			  datain0 : in  STD_LOGIC_VECTOR (31 downto 0);
           datain1 : in  STD_LOGIC_VECTOR (31 downto 0);
			  datain2 : in  STD_LOGIC_VECTOR (31 downto 0);
           datain3 : in  STD_LOGIC_VECTOR (31 downto 0);
           dataout : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

component MUX4_1_5bits is
    Port ( sel : in  STD_LOGIC_VECTOR(1 downto 0);
			  datain0 : in  STD_LOGIC_VECTOR (4 downto 0);
           datain1 : in  STD_LOGIC_VECTOR (4 downto 0);
			  datain2 : in  STD_LOGIC_VECTOR (4 downto 0);
           datain3 : in  STD_LOGIC_VECTOR (4 downto 0);
           dataout : out  STD_LOGIC_VECTOR (4 downto 0));
end component;

component Regis_2bits is
    Port ( CLK : in STD_LOGIC;
           WriteEnable : in STD_LOGIC;
           RST : in STD_LOGIC;
           Datain : in STD_LOGIC_VECTOR (1 downto 0);
           Dataout : out STD_LOGIC_VECTOR (1 downto 0));
end component;

signal mux_control : STD_LOGIC_VECTOR (1 downto 0);
signal tempout_Q : std_logic_vector (4 downto 0);
signal tempout_V : std_logic_vector (31 downto 0);
signal temp_grant1,temp_grant2,temp_grant3 : std_logic;
signal temp_wren : std_logic;
signal temp_last_served, temp_new_served : std_logic_vector(1 downto 0);

begin
mux_V:
	MUX4_1 port map(sel=>mux_control, datain0=>FU1_Vin(31 downto 0), datain1=>FU2_Vin(31 downto 0), 
					datain2=>FU3_Vin(31 downto 0),datain3=>x"00000000", dataout=>tempout_V);

mux_Q:
	MUX4_1_5bits port map(sel=>mux_control, datain0=>FU1_Qin(4 downto 0), datain1=>FU2_Qin(4 downto 0), 
					datain2=>FU3_Qin(4 downto 0),datain3=>"00000", dataout=>tempout_Q);

last_served:
	Regis_2bits port map (CLK=>CLK, RST=>RST, WriteEnable=>temp_wren, Datain=>temp_new_served, 
					Dataout=>temp_last_served);

--control process
process(CLK,RST,FU1_Req,FU2_Req,FU3_Req)
begin
	if rising_edge(CLK) then
		if RST='1' then
			temp_grant1<='0';
			temp_grant2<='0';
			temp_grant3<='0'; 
			mux_control<="11";
			temp_wren<='0'; 
			temp_new_served<="00";
		else
			if (FU1_Req='1' and FU2_Req='0' and FU3_Req='0') then
				temp_grant1<='1';
				temp_grant2<='0';
				temp_grant3<='0';
				mux_control<="00";
				temp_wren<='0';
				temp_new_served<="00";
			
			elsif (FU1_Req='0' and FU2_Req='1' and FU3_Req='0') then
				temp_grant1<='0';
				temp_grant2<='1';
				temp_grant3<='0';
				mux_control<="01";
				temp_wren<='0';
				temp_new_served<="00";
			
			elsif (FU1_Req='0' and FU2_Req='0' and FU3_Req='1') then
				temp_grant1<='0';
				temp_grant2<='0';
				temp_grant3<='1';	
				mux_control<="10";
				temp_wren<='0';
				temp_new_served<="00";
			
			elsif (FU1_Req='1' and FU2_Req='1' and FU3_Req='0') then
				if (temp_last_served="00" or temp_last_served="10" or temp_last_served="11") then
					temp_grant1<='1';
					temp_grant2<='0';
					temp_grant3<='0';	
					mux_control<="00";
					temp_wren<='1';
					temp_new_served<="01"; --FU1 served
				
				else 
					temp_grant1<='0';
					temp_grant2<='1';
					temp_grant3<='0';	
					mux_control<="01";
					temp_wren<='1';
					temp_new_served<="10"; --FU2 served
				end if;
				
			elsif (FU1_Req='1' and FU2_Req='0' and FU3_Req='1') then
				if (temp_last_served="00" or temp_last_served="11" or temp_last_served="10") then
					temp_grant1<='1';
					temp_grant2<='0';
					temp_grant3<='0';	
					mux_control<="00";
					temp_wren<='1';
					temp_new_served<="01"; --FU1 served
				
				else 
					temp_grant1<='0';
					temp_grant2<='0';
					temp_grant3<='1';	
					mux_control<="10";
					temp_wren<='1';
					temp_new_served<="11"; --FU3 served
				end if;
				
			elsif (FU1_Req='0' and FU2_Req='1' and FU3_Req='1') then
				if (temp_last_served="00" or temp_last_served="11" or temp_last_served="01") then
					temp_grant1<='0';
					temp_grant2<='1';
					temp_grant3<='0';	
					mux_control<="01";
					temp_wren<='1';
					temp_new_served<="10"; --FU2 served
				
				else 
					temp_grant1<='0';
					temp_grant2<='0';
					temp_grant3<='1';	
					mux_control<="10";
					temp_wren<='1';
					temp_new_served<="11"; --FU3 served
				end if;

			elsif (FU1_Req='1' and FU2_Req='1' and FU3_Req='1') then
				if (temp_last_served="00" or temp_last_served="01") then
					temp_grant1<='0';
					temp_grant2<='1';
					temp_grant3<='0';	
					mux_control<="01";
					temp_wren<='1';
					temp_new_served<="10"; --FU2 served
				
				elsif (temp_last_served="00" or temp_last_served="10") then
					temp_grant1<='0';
					temp_grant2<='0';
					temp_grant3<='1';	
					mux_control<="10";
					temp_wren<='1';
					temp_new_served<="11"; --FU3 served

				else 
					temp_grant1<='1';
					temp_grant2<='0';
					temp_grant3<='0';	
					mux_control<="00";
					temp_wren<='1';
					temp_new_served<="01"; --FU1 served
				end if;

			else
				temp_grant1<='0';
				temp_grant2<='0';
				temp_grant3<='0';
				mux_control<="11"; --no FU served
			end if;
		end if;
	end if;
end process;
 
--outputs
CDB_Q<=tempout_Q;
CDB_V<=tempout_V;
FU1_Grant<=temp_grant1;
FU2_Grant<=temp_grant2;
FU3_Grant<=temp_grant3;
		
end Behavioral;


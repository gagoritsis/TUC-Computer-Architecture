----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:17:31 04/09/2021 
-- Design Name: 
-- Module Name:    Regis_1bit - Behavioral 
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

entity Regis_1bit is
    Port ( CLK : in STD_LOGIC;
           WriteEnable : in STD_LOGIC;
           RST : in STD_LOGIC;
           Datain : in STD_LOGIC;
           Dataout : out STD_LOGIC);
end Regis_1bit;

architecture Behavioral of Regis_1bit is

signal tempOut: std_logic;

begin
process
begin
	wait until CLK'EVENT AND CLK='1';
	if RST='1' then
	   tempOut<='0'; 
		 
	else
	   if WriteEnable='1' then
	       tempOut<=Datain;
	   else
	       tempOut<=tempOut;
	   end if;
    end if;
end process;

Dataout<=tempOut;

end Behavioral;

----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:54:38 04/14/2021 
-- Design Name: 
-- Module Name:    Regis_2bits - Behavioral 
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

entity Regis_2bits is
    Port ( CLK : in STD_LOGIC;
           WriteEnable : in STD_LOGIC;
           RST : in STD_LOGIC;
           Datain : in STD_LOGIC_VECTOR (1 downto 0);
           Dataout : out STD_LOGIC_VECTOR (1 downto 0));

end Regis_2bits;

architecture Behavioral of Regis_2bits is
signal tempOut: std_logic_vector(1 downto 0);

begin
process
begin
	wait until CLK'EVENT AND CLK='1';
	if RST='1' then
	   tempOut<="00"; 
		 
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


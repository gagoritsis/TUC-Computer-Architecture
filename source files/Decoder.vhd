----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:11:40 04/12/2021 
-- Design Name: 
-- Module Name:    Decoder - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Decoder is
    Port ( Awr : in std_logic_vector (4 downto 0);
           Dout : out std_logic_vector (31 downto 0));
end Decoder;

architecture Behavioral of Decoder is

signal temp: std_logic_vector(31 downto 0);

begin

decode:
	for i in 0 to 31 generate 
		temp(i)<= '1' when to_integer(unsigned(Awr)) = i else '0';			
	end generate;

Dout<= temp;

end Behavioral;

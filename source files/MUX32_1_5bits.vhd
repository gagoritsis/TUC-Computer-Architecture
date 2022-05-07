----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:50:19 04/13/2021 
-- Design Name: 
-- Module Name:    MUX32_1_5bits - Behavioral 
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

use work.mux_pack.all;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MUX32_1_5bits is
    Port ( Min : in muxIn5bits;
           Control : in STD_LOGIC_VECTOR (4 downto 0);
           Mout : out STD_LOGIC_VECTOR (4 downto 0));
           
end MUX32_1_5bits;

architecture Behavioral of MUX32_1_5bits is

signal temp: std_logic_vector(4 downto 0);

begin
process(Min,Control,temp)
begin

temp<=std_logic_vector(Min(to_integer(unsigned(Control))));

end process;

Mout<=temp;


end Behavioral;

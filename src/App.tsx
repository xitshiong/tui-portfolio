import React, { useState, useEffect } from 'react';
import { Text, Box, useInput } from 'ink';
import SelectInput from 'ink-select-input';

// --- ASSETS: LOGO & PORTRAIT ---
const NAME_ART = `
       .__                 .__                 
  ____ |  |__ _____ _______|  |   ____   ______
_/ ___\\|  |  \\\\__  \\\\_  __ \\  | _/ __ \\ /  ___/
\\  \\___|   Y  \\/ __ \\|  | \\/  |_\\  ___/ \\___ \\ 
 \\___  >___|  (____  /__|  |____/\\___  >____  >
     \\/     \\/     \\/                \\/     \\/ 
`;

const PORTRAIT_ART = `
                                .                                          .                        
               .       .    ..              .        .     ..   ..       .           .          .   
              .                                                       .        .                    
.           .                              .                       .   .                            
.             .      ..             . .   +%%%%%##..      ..           .      . .     .             
                     .          .###%%###%%%%%%%%%%%%%:                      ..            ..       
          .              .    :%%%%#%%@@%%@@@@@%%#*#%%%%#   .      ..                          .    
       .  .   .      . ..  ..#%%#%%%%%@%%@@@@@%%%@%%%%%%##.           .  .    .  .   .        .     
       .                   .%%%%%%%#%@#%@@@@@%@%%%%%%%%%%##.    .                          .        
         .             .  .#%%#%%@@@%%##%@@@%@@@@@@%%%@%##%%#                                  .    
   .   .     ..     .  . ..#%#%%@@@%%%####%%%%%@@@@%@@@%@%%%%...                      . .   . .     
                        .=#%%%%@%%###*****#%%%#%%%%@%@@@%@%%%* .             .       . 
       .         .      =#%%%%@%####**++**###%%#@@%%@@@%%%%%%%- ..       .                          
    . . .            .  -#%%%@%%###**++*+***###%#%%@%%@@@@%@%%-   .                    .     .      
           .            -%%%@@@%**+++*+++*#@@@%%%@%#@##%%@@%%%:                                     
        ..     .      . +#%%%@%@%#*++*++*##***+*%#%###%###%%** .            .            
    .       . ..    .    #%%%-%****#*++*+***#%@%*#%##%*+%##+*+...      .      ..     ...   . .      
                         .*%%#.+%*@@**++++*%+=******+**+++***+                                      
 ........ ....  .......    .-:.+**#***+==++++**++++++++===+*+=  .  .. ... ...... .  . ... ..  .  .. 
             .     ..       .  =+++++++=++++++++++++====+=++=. .     .              ..            ..
                               =+++++====+++++===++====+==+=..                     .                
       ...   ... .   .. .   ....=+++++++++==+++===+==+====...   ...    . .    ...     ..  ..........
                                .+++++*+++++=++==+=======+=.                  ..           ..    .  
   .         .               .   .=+++++++++==++++======+@%*: .       ...     ...  .                
   .   .  . ...    .  .     ..   ..++*+#+*****+++======++%@@%:   .             .              . . ..
       .                   .       *+**#***#++++++++=+****@@@#+              .      .             . 
          ...    ...            . .**+******++++++++*#***#@@##+    .     ..       .       .  .. . ..
      .  .    .       .   .. =++**==#*#*++++++++++####**##@@%** .   .. .     ..      ..  .  .     
.      .       . .   .=****#*#-#=#=+=+%##%*****%%%%%%###*****+::.                     .     ..      
.     .   ... . ...***=*###+##===##%#%%##%%%%#%#%##@@#%###**#++..+.:..            .     . .. .......
 ......... ....+-=*+#=-=####%#==#####%%%%##%%%####%#%%%#*##**+++++#:=:=.......................  ... 
   .   .+*+=-**====+=########%################%%#%#%##%%#**#***+++++*:++:. ..  . . .      ..........
      .*##-*=-#*#+=+=*###%###%########*#######%###%@###***#***++++++++++:=:.  .    . . ..    . . .  
.     +*#=*=##-=###%#######*#%%##################**%*###******++++++++++++:-       .  ... .. ..... .
 . ...-==*+#-+#####%#####%#################--==:-=-=####******++++*+++++++++:.. .. ..     ..........
...++--**++#*####*###################*##*******###===-::--:#**+*++*+++++++*++=..... . ..............
.****-=*-==*###%#########%#####*#####**##***####*****#*******+++++++++++++*++:=-    ....  ..........
****--*---##%####%#*#####%#####***####****#**#****************+*++++++++++****-=. ...    .          
***--**--*#==%###%#***########****##*##***##****************+*++++++++++++**+*+.:     . .......... .
**--#*--*+-=##%#%%#*#*#########********#****#*****#*********+**+++++++++++**++*+:...... ....... ....
`;

interface MenuItem {
    label: string;
    value: string;
}

const App = () => {
    const [screen, setScreen] = useState('home');
    const [activeLabel, setActiveLabel] = useState('SYSTEM_IDLE');
    const [showStars, setShowStars] = useState(true);

    // --- ANIMATION: Blinking Stars Timer ---
    useEffect(() => {
        const timer = setInterval(() => {
            setShowStars(prev => !prev);
        }, 500);
        return () => clearInterval(timer);
    }, []);

    // --- KEYBOARD: Shortcuts ---
    useInput((_input, key) => {
        if (key.escape || key.backspace) {
            setScreen('home');
            setActiveLabel('SYSTEM_IDLE');
        }
    });

    const handleSelect = (item: MenuItem) => {
        if (item.value === 'exit') process.exit();
        setScreen(item.value);
        setActiveLabel(item.label.toUpperCase());
    };

    const star = showStars ? '*' : ' ';

    return (
        <Box flexDirection="row" padding={1} minHeight={45}>

            {/* --- LEFT SIDE: PORTRAIT (No Border) --- */}
            <Box flexDirection="column" paddingRight={2}>
                <Text color="white" dimColor> [ BIOMETRIC_SCAN ] </Text>
                <Text color="white" wrap="none">{PORTRAIT_ART}</Text>
                <Text color="white" dimColor alignSelf="center"> ID: CHARLES_KOK_77 </Text>
            </Box>

            {/* --- RIGHT SIDE: ALL INFO --- */}
            <Box flexDirection="column" paddingLeft={2} flexGrow={1}>

                {/* 1. Header Bar */}
                <Box justifyContent="space-between" marginBottom={1} borderStyle="single" borderTop={false} borderLeft={false} borderRight={false} borderColor="gray">
                    <Text color="white" bold> ⚡ CK_OS v2.0 </Text>
                    <Text color="gray"> STATUS: <Text color="yellow">{activeLabel}</Text> </Text>
                </Box>

                {/* 2. Blinking Name Header */}
                <Box flexDirection="column" marginBottom={1} alignItems="center">
                    <Box flexDirection="row">
                        <Text color="yellow" bold>{star}{star}{star} </Text>
                        <Text color="yellow" bold>{NAME_ART}</Text>
                        <Text color="yellow" bold> {star}{star}{star}</Text>
                    </Box>
                    <Text color="gray"> ↳ Monash University | Biz & CS </Text>
                </Box>

                {/* 3. Navigation Menu */}
                <Box flexDirection="column" borderStyle="round" borderColor="white" paddingX={2} paddingY={1} marginBottom={1}>
                    <Text color="white" bold underline> MAIN_NAVIGATION </Text>
                    <Box marginTop={1}>
                        <SelectInput
                            items={[
                                { label: '🎓 Education', value: 'edu' },
                                { label: '💼 Experience', value: 'work' },
                                { label: '👥 Leadership', value: 'lead' },
                                { label: '📞 Contact', value: 'contact' },
                                { label: '❌ Exit', value: 'exit' },
                            ]}
                            onSelect={handleSelect}
                        />
                    </Box>
                </Box>

                {/* 4. Content Area (Visual Contrast) */}
                <Box flexGrow={1} borderStyle="single" borderColor="gray" paddingX={2} paddingY={1}>
                    {screen === 'home' && (
                        <Box flexDirection="column" alignItems="center" justifyContent="center" flexGrow={1}>
                            <Text color="gray"> WAITING FOR MODULE INPUT... </Text>
                            <Text color="gray" dimColor> [Use Arrows + Enter] </Text>
                        </Box>
                    )}

                    {screen === 'edu' && (
                        <Box flexDirection="column">
                            <Text bold color="blue">🎓 EDUCATION & SKILLS</Text>
                            <Text marginTop={1} color="white" bold>Monash University (2028)</Text>
                            <Text color="gray">Bachelor of Business and Commerce and Bachelor of Computer Science</Text>
                            <Text marginTop={1} color="white" bold>Sri Kuala Lumpur (2023)</Text>
                            <Text color="gray">IGCSE 9A*s</Text>
                            <Box marginTop={1} borderStyle="classic" borderColor="white" paddingX={1}>
                                <Text color="white">SKILLS: Python, C++, HTML, React, JS</Text>
                            </Box>
                        </Box>
                    )}

                    {screen === 'work' && (
                        <Box flexDirection="column">
                            <Text bold color="green">💼 EXPERIENCE LOG</Text>
                            <Box marginTop={1} flexDirection="column">
                                <Text bold color="white">FOS Malaysia | Merchandiser</Text>
                                <Text color="yellow">Issueing PO's, Graphic Design</Text>
                                <Text color="gray">• Managed 100+ outlets, Chinese suppliers, PANTONE stds.</Text>
                            </Box>
                            <Box marginTop={1} flexDirection="column">
                                <Text bold color="white">HYGR | Marketing Creative</Text>
                                <Text color="yellow">• Video editing and KOL outreach campaigns.</Text>
                            </Box>
                        </Box>
                    )}

                    {screen === 'lead' && (
                        <Box flexDirection="column">
                            <Text bold color="magenta">👥 LEADERSHIP PROTOCOLS</Text>
                            <Text marginTop={1} color="white">• Monash Biz Club: Deputy Director Creativity (2025)</Text>
                            <Text color="white">• MUFY Student Council: Publicity Officer (Sunway, 2024)</Text>
                            <Text color="white">• Illusionist Club: President (SRI KL, 2023)</Text>
                        </Box>
                    )}

                    {screen === 'contact' && (
                        <Box flexDirection="column" alignItems="center" justifyContent="center" flexGrow={1}>
                            <Box backgroundColor="yellow" paddingX={2} marginBottom={1}>
                                <Text color="black" bold> 📞 CONTACT ESTABLISHED </Text>
                            </Box>
                            <Text color="white">Phone: +60 11 6166 5322</Text>
                            <Text color="white" bold underline>ckok0012@student.monash.edu</Text>

                            <Box marginTop={2} borderStyle="double" borderColor="gray" paddingX={2}>
                                <Text italic color="white"> "He's serious now." </Text>
                            </Box>
                        </Box>
                    )}
                </Box>

                {/* 5. Footer Bar */}
                <Box marginTop={1} justifyContent="center">
                    <Text color="gray" dimColor> [ESC] RESET | [CTRL+C] TERMINATE SESSION </Text>
                </Box>
            </Box>
        </Box>
    );
};

export default App;
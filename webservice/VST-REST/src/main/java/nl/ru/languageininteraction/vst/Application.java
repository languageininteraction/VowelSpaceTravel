package nl.ru.languageininteraction.vst;

import java.util.Date;
import nl.ru.languageininteraction.vst.model.Player;
import nl.ru.languageininteraction.vst.model.StimulusResponse;
import nl.ru.languageininteraction.vst.model.Vowel;
import nl.ru.languageininteraction.vst.rest.ConsonantRepository;
import nl.ru.languageininteraction.vst.rest.PlayerRepository;
import nl.ru.languageininteraction.vst.rest.StimulusResponseRepository;
import nl.ru.languageininteraction.vst.rest.VowelRepository;
import nl.ru.languageininteraction.vst.rest.WordRepository;
import nl.ru.languageininteraction.vst.util.DefaultData;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;

/**
 * @since Apr 2, 2015 4:58:19 PM (creation date)
 * @author Peter Withers <p.withers@psych.ru.nl>
 */
@Configuration
@EnableAutoConfiguration
@ComponentScan
public class Application implements CommandLineRunner {

    @Autowired
    private VowelRepository vowelRepository;
    @Autowired
    private PlayerRepository playerRepository;
    @Autowired
    private StimulusResponseRepository stimulusResultRepository;
    @Autowired
    private WordRepository wordsRepository;
    @Autowired
    private ConsonantRepository consonantRepository;

    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }

    @Override
    public void run(String... args) throws Exception {
        vowelRepository.deleteAll();
        playerRepository.deleteAll();
        wordsRepository.deleteAll();
        stimulusResultRepository.deleteAll();
        consonantRepository.deleteAll();

        DefaultData defaultData = new DefaultData(vowelRepository, playerRepository, stimulusResultRepository, wordsRepository, consonantRepository);
        defaultData.insertVowels();
        defaultData.insertConsonants();
        defaultData.insertWords();

        System.out.println("Vowels");
        for (Vowel vowel : vowelRepository.findAll()) {
            System.out.println(vowel);
        }
        System.out.println();

        System.out.println("vowels with ipa 'I'");
        System.out.println(vowelRepository.findByIpa("I"));
        final Player player = new Player("fred@blogs.none", 1234);
        player.setFirstName("Fred");
        player.setLastName("Blogs");
        playerRepository.save(player);
//        final StimulusResponse stimulusResult = new StimulusResponse(player, vowelRepository.findByIpa("I"), vowelRepository.findByIpa("E"), true, false, false, false, new Date().getTime());
//        stimulusResultRepository.save(stimulusResult);
        stimulusResultRepository.save(new StimulusResponse(player, vowelRepository.findByIpa("I"), vowelRepository.findByIpa("E"), true, false, false, false, new Date().getTime()));
        stimulusResultRepository.save(new StimulusResponse(player, vowelRepository.findByIpa("I"), vowelRepository.findByIpa("E"), false, true, false, false, new Date().getTime()));
        stimulusResultRepository.save(new StimulusResponse(player, vowelRepository.findByIpa("{"), vowelRepository.findByIpa("V"), false, false, false, true, new Date().getTime()));
        System.out.println("Players");
        for (Player currentPlayer : playerRepository.findAll()) {
            System.out.println(currentPlayer);
        }
        System.out.println();
    }
}

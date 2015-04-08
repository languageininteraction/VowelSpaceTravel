package nl.ru.languageininteraction.vst;

import java.util.Date;
import nl.ru.languageininteraction.vst.model.Player;
import nl.ru.languageininteraction.vst.model.StimulusResult;
import nl.ru.languageininteraction.vst.model.Vowel;
import nl.ru.languageininteraction.vst.model.Word;
import nl.ru.languageininteraction.vst.rest.PlayerRepository;
import nl.ru.languageininteraction.vst.rest.StimulusResultRepository;
import nl.ru.languageininteraction.vst.rest.VowelRepository;
import nl.ru.languageininteraction.vst.rest.WordsRepository;
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
    private StimulusResultRepository stimulusResultRepository;
    @Autowired
    private WordsRepository wordsRepository;

    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }

    @Override
    public void run(String... args) throws Exception {
        vowelRepository.deleteAll();
        playerRepository.deleteAll();

        vowelRepository.save(new Vowel(1L, "a", "a", Vowel.Place.back, Vowel.Manner.close, Vowel.Roundness.rounded));
        vowelRepository.save(new Vowel(2L, "b", "b", Vowel.Place.central, Vowel.Manner.close_mid, Vowel.Roundness.unrounded));

        System.out.println("Vowels");
        for (Vowel vowel : vowelRepository.findAll()) {
            System.out.println(vowel);
        }
        System.out.println();

        System.out.println("vowels with ipa 'a'");
        System.out.println(vowelRepository.findByIpa("a"));
        final Player player = new Player("Fred", "Blogs");
        final Word word = new Word("woof", vowelRepository.findByIpa("a"));
        wordsRepository.save(word);
        playerRepository.save(player);
        final StimulusResult stimulusResult = new StimulusResult(player, word, new Date().getTime());
        stimulusResultRepository.save(stimulusResult);
//        player.addResult(stimulusResultRepository.findAll().iterator().next());
        System.out.println("Players");
        for (Player currentPlayer : playerRepository.findAll()) {
            System.out.println(currentPlayer);
        }
        System.out.println();
    }
}

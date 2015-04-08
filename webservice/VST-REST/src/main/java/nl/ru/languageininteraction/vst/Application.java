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
        wordsRepository.deleteAll();
        stimulusResultRepository.deleteAll();

        insertVowels();

        System.out.println("Vowels");
        for (Vowel vowel : vowelRepository.findAll()) {
            System.out.println(vowel);
        }
        System.out.println();

        System.out.println("vowels with ipa 'I'");
        System.out.println(vowelRepository.findByIpa("I"));
        final Player player = new Player("Fred", "Blogs");
        final Word word = new Word("woof", vowelRepository.findByIpa("a"));
        wordsRepository.save(word);
        playerRepository.save(player);
        final StimulusResult stimulusResult = new StimulusResult(player, vowelRepository.findByIpa("I"), vowelRepository.findByIpa("E"), true, false, false, false, new Date().getTime());
        stimulusResultRepository.save(stimulusResult);
        System.out.println("Players");
        for (Player currentPlayer : playerRepository.findAll()) {
            System.out.println(currentPlayer);
        }
        System.out.println();
    }

    private void insertVowels() {
        vowelRepository.save(new Vowel("I", "", Vowel.Place.near_front, Vowel.Manner.near_close, Vowel.Roundness.unrounded));
        vowelRepository.save(new Vowel("E", "", Vowel.Place.front, Vowel.Manner.open_mid, Vowel.Roundness.unrounded));
        vowelRepository.save(new Vowel("{", "", Vowel.Place.front, Vowel.Manner.near_open, Vowel.Roundness.unrounded));
        vowelRepository.save(new Vowel("V", "", Vowel.Place.back, Vowel.Manner.open_mid, Vowel.Roundness.unrounded));
        vowelRepository.save(new Vowel("Q", "", Vowel.Place.back, Vowel.Manner.open, Vowel.Roundness.rounded));
        vowelRepository.save(new Vowel("U", "", Vowel.Place.near_back, Vowel.Manner.near_close, Vowel.Roundness.rounded));
        vowelRepository.save(new Vowel("i", "", Vowel.Place.front, Vowel.Manner.close, Vowel.Roundness.unrounded));
        vowelRepository.save(new Vowel("#", "", Vowel.Place.back, Vowel.Manner.open, Vowel.Roundness.unrounded));
        vowelRepository.save(new Vowel("$", "", Vowel.Place.back, Vowel.Manner.open_mid, Vowel.Roundness.rounded));
        vowelRepository.save(new Vowel("u", "", Vowel.Place.back, Vowel.Manner.close, Vowel.Roundness.rounded));
        vowelRepository.save(new Vowel("3", "", Vowel.Place.central, Vowel.Manner.open_mid, Vowel.Roundness.unrounded));
        vowelRepository.save(new Vowel("1", "", Vowel.Place.near_front, Vowel.Manner.near_close, Vowel.Roundness.unrounded));
        vowelRepository.save(new Vowel("2", "", Vowel.Place.near_front, Vowel.Manner.near_close, Vowel.Roundness.unrounded));
        vowelRepository.save(new Vowel("4", "", Vowel.Place.near_front, Vowel.Manner.near_close, Vowel.Roundness.unrounded));
        vowelRepository.save(new Vowel("5", "", Vowel.Place.near_back, Vowel.Manner.near_close, Vowel.Roundness.unrounded));
        vowelRepository.save(new Vowel("6", "", Vowel.Place.near_back, Vowel.Manner.near_close, Vowel.Roundness.unrounded));
        vowelRepository.save(new Vowel("1", "", Vowel.Place.front, Vowel.Manner.close_mid, Vowel.Roundness.unrounded));
        vowelRepository.save(new Vowel("2", "", Vowel.Place.front, Vowel.Manner.open, Vowel.Roundness.unrounded));
        vowelRepository.save(new Vowel("4", "", Vowel.Place.back, Vowel.Manner.open_mid, Vowel.Roundness.rounded));
        vowelRepository.save(new Vowel("5", "", Vowel.Place.central, Vowel.Manner.mid, Vowel.Roundness.unrounded));
        vowelRepository.save(new Vowel("6", "", Vowel.Place.front, Vowel.Manner.open, Vowel.Roundness.unrounded));
    }
}

package nl.ru.languageininteraction.vst;

import java.util.Date;
import nl.ru.languageininteraction.vst.model.Consonant;
import nl.ru.languageininteraction.vst.model.Player;
import nl.ru.languageininteraction.vst.model.StimulusResponse;
import nl.ru.languageininteraction.vst.model.Vowel;
import nl.ru.languageininteraction.vst.model.Word;
import nl.ru.languageininteraction.vst.rest.ConsonantRepository;
import nl.ru.languageininteraction.vst.rest.PlayerRepository;
import nl.ru.languageininteraction.vst.rest.StimulusResponseRepository;
import nl.ru.languageininteraction.vst.rest.VowelRepository;
import nl.ru.languageininteraction.vst.rest.WordRepository;
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

        insertVowels();

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
        final Consonant consonantW = new Consonant("w");
        consonantRepository.save(consonantW);
        final Consonant consonantF = new Consonant("f");
        consonantRepository.save(consonantF);
        final Word word = new Word("woof", consonantW, vowelRepository.findByIpa("a"), consonantF);
        wordsRepository.save(word);
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

    private void insertVowels() {
        vowelRepository.save(new Vowel("I", "I", Vowel.Place.near_front, Vowel.Manner.near_close, Vowel.Roundness.unrounded));
        vowelRepository.save(new Vowel("E", "E", Vowel.Place.front, Vowel.Manner.open_mid, Vowel.Roundness.unrounded));
        vowelRepository.save(new Vowel("{", "{", Vowel.Place.front, Vowel.Manner.near_open, Vowel.Roundness.unrounded));
        vowelRepository.save(new Vowel("V", "V", Vowel.Place.back, Vowel.Manner.open_mid, Vowel.Roundness.unrounded));
        vowelRepository.save(new Vowel("Q", "Q", Vowel.Place.back, Vowel.Manner.open, Vowel.Roundness.rounded));
        vowelRepository.save(new Vowel("U", "U", Vowel.Place.near_back, Vowel.Manner.near_close, Vowel.Roundness.rounded));
        vowelRepository.save(new Vowel("i", "i", Vowel.Place.front, Vowel.Manner.close, Vowel.Roundness.unrounded));
        vowelRepository.save(new Vowel("#", "#", Vowel.Place.back, Vowel.Manner.open, Vowel.Roundness.unrounded));
        vowelRepository.save(new Vowel("$", "$", Vowel.Place.back, Vowel.Manner.open_mid, Vowel.Roundness.rounded));
        vowelRepository.save(new Vowel("u", "u", Vowel.Place.back, Vowel.Manner.close, Vowel.Roundness.rounded));
        vowelRepository.save(new Vowel("3", "3", Vowel.Place.central, Vowel.Manner.open_mid, Vowel.Roundness.unrounded));
        vowelRepository.save(new Vowel("1", "1", Vowel.Place.near_front, Vowel.Manner.near_close, Vowel.Roundness.unrounded));
        vowelRepository.save(new Vowel("2", "2", Vowel.Place.near_front, Vowel.Manner.near_close, Vowel.Roundness.unrounded));
        vowelRepository.save(new Vowel("4", "4", Vowel.Place.near_front, Vowel.Manner.near_close, Vowel.Roundness.unrounded));
        vowelRepository.save(new Vowel("5", "5", Vowel.Place.near_back, Vowel.Manner.near_close, Vowel.Roundness.unrounded));
        vowelRepository.save(new Vowel("6", "6", Vowel.Place.near_back, Vowel.Manner.near_close, Vowel.Roundness.unrounded));
        vowelRepository.save(new Vowel("1", "1", Vowel.Place.front, Vowel.Manner.close_mid, Vowel.Roundness.unrounded));
        vowelRepository.save(new Vowel("2", "2", Vowel.Place.front, Vowel.Manner.open, Vowel.Roundness.unrounded));
        vowelRepository.save(new Vowel("4", "4", Vowel.Place.back, Vowel.Manner.open_mid, Vowel.Roundness.rounded));
        vowelRepository.save(new Vowel("5", "5", Vowel.Place.central, Vowel.Manner.mid, Vowel.Roundness.unrounded));
        vowelRepository.save(new Vowel("6", "6", Vowel.Place.front, Vowel.Manner.open, Vowel.Roundness.unrounded));
    }
}

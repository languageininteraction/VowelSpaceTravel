/*
 * Copyright (C) 2015 Language In Interaction
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
 */
package nl.ru.languageininteraction.vst.rest;

import java.util.List;
import nl.ru.languageininteraction.vst.model.Confidence;
import nl.ru.languageininteraction.vst.model.Difficulty;
import nl.ru.languageininteraction.vst.model.Player;
import nl.ru.languageininteraction.vst.model.Task;
import nl.ru.languageininteraction.vst.model.Vowel;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;
import org.springframework.data.rest.core.annotation.RestResource;

/**
 * @since Jun 4, 2015 2:17:51 PM (creation date)
 * @author petwit
 */
@RepositoryRestResource(collectionResourceRel = "confidence", path = "confidence")
public interface ConfidenceRepository extends PagingAndSortingRepository<Confidence, Long> {

    public List<Confidence> findAll();

    public List<Confidence> findByPlayerAndTaskAndDifficulty(
            @Param("player") Player player,
            @Param("task") Task task,
            @Param("difficulty") Difficulty difficulty);

    @RestResource(exported = false)
    public void deleteByPlayerAndTaskAndDifficultyAndTargetVowelAndStandardVowel(
            @Param("player") Player player,
            @Param("task") Task task,
            @Param("difficulty") Difficulty difficulty,
            @Param("targetVowel") Vowel targetVowel,
            @Param("standardVowel") Vowel standardVowel);

    public List<Confidence> findByPlayer(@Param("player") Player player);

    public List<Confidence> findByTask(@Param("task") Task task);

    public List<Confidence> findByDifficulty(@Param("difficulty") Difficulty difficulty);

    @Override
    @RestResource(exported = false)
    public <S extends Confidence> Iterable<S> save(Iterable<S> entities);

    @Override
    @RestResource(exported = false)
    public void deleteAll();

    @Override
    @RestResource(exported = false)
    public void delete(Iterable<? extends Confidence> entities);

    @Override
    @RestResource(exported = false)
    public <S extends Confidence> S save(S entity);

    @Override
    @RestResource(exported = false)
    public void delete(Confidence entity);

    @Override
    @RestResource(exported = false)
    public void delete(Long id);
}

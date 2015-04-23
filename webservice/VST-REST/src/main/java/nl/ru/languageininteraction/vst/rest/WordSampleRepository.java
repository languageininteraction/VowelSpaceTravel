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

import nl.ru.languageininteraction.vst.model.WordSample;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;
import org.springframework.data.rest.core.annotation.RestResource;

/**
 * @since Apr 8, 2015 5:12:19 PM (creation date)
 * @author Peter Withers <p.withers@psych.ru.nl>
 */
@RepositoryRestResource(collectionResourceRel = "wordsamples", path = "wordsamples")
public interface WordSampleRepository extends PagingAndSortingRepository<WordSample, Long> {

    @Override
    @RestResource(exported = false)
    public <S extends WordSample> Iterable<S> save(Iterable<S> entities);

    @Override
    @RestResource(exported = false)
    public void deleteAll();

    @Override
    @RestResource(exported = false)
    public void delete(Iterable<? extends WordSample> entities);

    @Override
    @RestResource(exported = false)
    public <S extends WordSample> S save(S entity);

    @Override
    @RestResource(exported = false)
    public void delete(WordSample entity);

    @Override
    @RestResource(exported = false)
    public void delete(Long id);
}

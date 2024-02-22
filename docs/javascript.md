# Javascript

## Transform into esm
const\s+(\w+|{(\s*\w+,)\s\w+\s*})\s+=\s+require('([^']+)');?

import $1 from '$3';

## Templated returns

Thanks to: https://stackoverflow.com/a/63791858/1954789
/**
 * @template T
 * @param {new() => T} ObjectConstructor
 * @returns {T}
 */
function createInstanceOf(ObjectConstructor) {
  return new ObjectConstructor;
}
